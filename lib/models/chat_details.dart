import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDetails {
  String? key;
  String? lastMessage;
  Timestamp? lastMessageTime;
  List? lastMessageSeen;
  List? users;

  ChatDetails({
    this.key,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSeen,
    this.users,
  });

  ChatDetails.fromJson(Map<String, dynamic>? doc) {
    if (doc != null) {
      key = doc['key'] as String?;
      lastMessage = doc['lastMessage'] as String?;
      lastMessageTime = doc['lastMessageTime'] as Timestamp?;
      lastMessageSeen = doc['lastMessageSeen'] as List?;
      users = doc['users'] as List?;
    }
  }
}
