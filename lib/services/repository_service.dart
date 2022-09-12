import 'dart:convert';

import 'package:chat_translator/models/chat_info.dart';
import 'package:chat_translator/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as en;
import 'package:random_string/random_string.dart';

class RepositoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setUserData(UserData userData) async {
    await _firestore.collection('users').doc(userData.id).set(userData.toMap(), SetOptions(merge: true));
  }

  Future<UserData?> getUserData(String userId) async {
    ///currentUser= true, means fcmToken will be updated.
    ///Do Not set currentUser=true for other user
    var result = await _firestore.collection('users').doc(userId).get();
    // if (currentUser) {
    //   try {
    //     if (result.exists) {
    //       //update users token!
    //       await _firestore.collection('users').doc(userId).update({"firebaseToken": await FirebaseMessaging.instance.getToken()});
    //       result = await _firestore.collection('users').doc(userId).get();
    //     }
    //   } catch (e) {
    //     await _firestore.collection('users').doc(userId).update({"firebaseToken": await FirebaseMessaging.instance.getToken()});
    //     result = await _firestore.collection('users').doc(userId).get();
    //   }
    // }
    final Map<String, dynamic>? doc = result.data();
    return doc == null ? null : UserData.fromJson(doc);
  }

  Future<List<DocumentSnapshot>> performSearch(Map<String, dynamic> searchParameters) async {
    Query query = _firestore.collection("users");
    searchParameters.forEach(
      (field, value) {
        if (value != "") {
          if (field == "native_lang") {
            query = query.where("nativeLanguage", isEqualTo: value);
          } else if (field == "learning_lang") {
            query = query.where("learningLanguage", isEqualTo: value);
          } else if (field == "country") {
            query = query.where("country", isEqualTo: value);
          } else if (field == "gender") {
            query = query.where("gender", isEqualTo: value);
          }
          // else if (field == "age_range") {
          //   query = '$query&age_range=$value';
          // }
          else {
            query = query.where(field, isEqualTo: value);
          }
        }
      },
    );
    QuerySnapshot result = await query.get();
    List<DocumentSnapshot> resultDocs = result.docs;
    return resultDocs;
  }

  /// Check If Document Exists
  Future<bool> checkDocExists(String docId) async {
    try {
      var doc = await _firestore.collection("messages").doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future<void> createChat(String chatId, String fromUserId, String toUserId) async {
    var doc = await _firestore.collection("messages").doc(chatId).get();
    doc.exists;
    await _firestore.collection("messages").doc(chatId).set({
      "isActive": true,
      "users": [fromUserId, toUserId]
    });
  }

  Future<void> sendMessage(
    ChatInfo chatInfo,
    String content,
    int type,
  ) async {
    final chatReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(chatInfo.getChatId())
        .collection(chatInfo.getChatId())
        .doc(Timestamp.now().millisecondsSinceEpoch.toString());

    //************ENCRYPTION*****************

    en.Key key;
    en.Encrypted encrypted;
    final msgDoc = _firestore.collection('messages').doc(chatInfo.getChatId());
    final msgValue = await msgDoc.get();
    if (msgValue.data()!['key'] != null) {
      key = en.Key(base64.decode(msgValue.data()!['key'].toString()));
    } else {
      String random32String = randomString(32);
      key = en.Key.fromUtf8(random32String);

      msgDoc.update({'key': key.base64});
    }

    final iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(key));
    encrypted = encrypter.encrypt(content, iv: iv);

    //************ENCRYPTION*****************

    return _firestore.runTransaction((transaction) async {
      transaction.set(
        chatReference,
        {
          'idFrom': chatInfo.fromUser.id,
          'idTo': chatInfo.toUser.id,
          'timestamp': Timestamp.now().millisecondsSinceEpoch.toString(),
          'content': encrypted.base64,
          'type': type,
          'contentLang': chatInfo.fromUser.nativeLanguage,
        },
      );
    });
  }

  Future<void> setChatLastMsg(ChatInfo chatInfo, String lastContent) async {
    final chatReference = FirebaseFirestore.instance.collection('messages').doc(chatInfo.getChatId());

    return _firestore.runTransaction((transaction) async {
      transaction.update(
        chatReference,
        {
          'lastMessage': lastContent,
          'lastMessageTime': Timestamp.now(),
          "lastMessageSeen": [chatInfo.fromUser.id]
        },
      );
    });
  }

  Stream<QuerySnapshot> getChats(String uid, int chatLimit) {
    return _firestore
        .collection('messages')
        .where("users", arrayContains: uid)
        .where("isActive", isEqualTo: true)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getMessages(String messageID, int messageLimit) {
    return _firestore
        .collection('messages')
        .doc(messageID)
        .collection(messageID)
        .orderBy('timestamp', descending: true)
        .limit(messageLimit)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getChatDetails(String chatId) async {
    return await _firestore.collection("messages").doc(chatId).get();
  }

  Future<void> updateEncryptionKey({required String chatId}) async {
    String random32String = randomString(32);
    en.Key key = en.Key.fromUtf8(random32String);
    await _firestore.collection("messages").doc(chatId).update({'key': key.base64});
  }

  Future<void> encryptAndStoreTranslation({
    required String translation,
    required String translatedLang,
    required String chatId,
    required String messageId,
    required String uid,
    required String encryptionKey,
  }) async {
    //encrypting translated msg
    final en.Key key = en.Key(base64.decode(encryptionKey.toString()));
    final iv = en.IV.fromLength(16);
    final encryptor = en.Encrypter(en.AES(key));
    final en.Encrypted encrypted = encryptor.encrypt(translation, iv: iv);
    //saving translated content in db
    _firestore.collection("messages").doc(chatId).collection(chatId).doc(messageId).update({
      "translatedContent": encrypted.base64,
      "translatedContentLang": translatedLang,
      "${uid}_showTrans": true,
    });
  }

  Future<void> closeTranslation(String chatId, String messageId, String uid) async {
    _firestore.collection("messages").doc(chatId).collection(chatId).doc(messageId).update({
      "${uid}_showTrans": false,
    });
  }
}
