import 'dart:convert';

import 'package:chat_translator/models/chat_details.dart';
import 'package:chat_translator/models/chat_info.dart';
import 'package:chat_translator/models/message.dart';
import 'package:chat_translator/models/translation.dart';
import 'package:chat_translator/models/user.dart';
import 'package:chat_translator/services/auth_service.dart';
import 'package:chat_translator/services/repository_service.dart';
import 'package:chat_translator/utils/translate_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as EN;
import 'package:flutter/cupertino.dart';

class ChatProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final RepositoryService _repositoryService = RepositoryService();

  String _key = "";
  bool _chatLoading = true;
  List<ChatDetails> _chats = [];
  List<Message> _messages = [];
  bool _otherUserLoading = true;

  String get key => _key;
  bool get chatLoading => _chatLoading;
  List get chats => _chats;
  List get messages => _messages;
  bool get otherUserLoading => _otherUserLoading;

  set chatLoading(bool value) {
    _chatLoading = value;
    notifyListeners();
  }

  set otherUserLoading(bool value) {
    _otherUserLoading = value;
    notifyListeners();
  }

  Future<bool> checkDocExists(String docId) async {
    return await _repositoryService.checkDocExists(docId);
  }

  Future<void> createChat(ChatInfo chatInfo) async {
    await _repositoryService.createChat(chatInfo.getChatId(), chatInfo.fromUser.id, chatInfo.toUser.id);
  }

  Future<void> sendMessage(ChatInfo chatInfo, String content, int type) async {
    await _repositoryService.sendMessage(chatInfo, content, type);
    await _repositoryService.setChatLastMsg(chatInfo, content);
  }

  Future<void> getChats() async {
    _repositoryService.getChats(_authService.uid() ?? "", 20).listen((event) {
      var docs = event.docs;
      _chats.clear();
      for (var element in docs) {
        _chats.add(ChatDetails.fromJson(element.data() as Map<String, dynamic>));
      }
      notifyListeners();
    });
  }

  Future<void> getMessages(ChatInfo chatInfo) async {
    _repositoryService.getMessages(chatInfo.getChatId(), 20).listen((event) {
      var docs = event.docs;
      _messages.clear();
      for (var element in docs) {
        _messages.add(Message.fromJson(element.data() as Map<String, dynamic>, element.id, _authService.uid() ?? ""));
        notifyListeners();
      }
    });
  }

  Future<void> getChatDetails(String chatId) async {
    DocumentSnapshot<Map<String, dynamic>> chatDetails = await _repositoryService.getChatDetails(chatId);
    ChatDetails.fromJson(chatDetails.data());
  }

  Future<void> getEncryptionKey(String chatId) async {
    DocumentSnapshot<Map<String, dynamic>> chatDetailsSnapshot = await _repositoryService.getChatDetails(chatId);
    ChatDetails chatDetails = ChatDetails.fromJson(chatDetailsSnapshot.data());
    if (chatDetails.key != null) {
      _key = chatDetails.key!;
    } else {
      _repositoryService.updateEncryptionKey(chatId: chatId);
    }
    notifyListeners();
  }

  String decryptMsg(String msg, String encryptionKey) {
    String message = "";
    try {
      EN.Key key = EN.Key(base64.decode(encryptionKey));
      final iv = EN.IV.fromLength(16);
      final encryptor = EN.Encrypter(EN.AES(key));
      var decodedMsgB64 = base64.decode(msg);
      message = encryptor.decrypt(EN.Encrypted(decodedMsgB64), iv: iv);
    } catch (e) {
      print(e);
    }
    return message;
  }

  String? uid() {
    return _authService.uid();
  }

  bool sendByMe(String uid) {
    return _authService.uid() == uid;
  }

  Future<UserData?> getOtherUserData(String uid) async {
    UserData? userData = await _repositoryService.getUserData(uid);
    _otherUserLoading = false;
    return userData;
  }

  Future<void> translate(
      {required String message,
      required String chatId,
      required String messageId,
      required String targetLanguage,
      required String encryptionKey}) async {
    TranslationBody translationBody = TranslationBody();
    String translatedText;
    // String translatedLang = "";
    try {
      translationBody = await TranslateUtils.translate(message, targetLanguage);

      translatedText = translationBody.translatedBody.toString();

      _repositoryService.encryptAndStoreTranslation(
          translation: translatedText,
          translatedLang: targetLanguage,
          chatId: chatId,
          messageId: messageId,
          uid: _authService.uid() ?? "",
          encryptionKey: encryptionKey);
    } catch (e) {
      print(e);
    }
  }

  Future<void> closeTranslation({required String chatId, required String messageId}) async {
    await _repositoryService.closeTranslation(chatId, messageId, _authService.uid() ?? "");
  }
}
