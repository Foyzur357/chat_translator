import 'package:chat_translator/models/user.dart';

class ChatInfo {
  late UserData fromUser;
  late UserData toUser;

  ChatInfo({required this.fromUser, required this.toUser});

  Map<String, dynamic> toMap() {
    return {"fromUser": fromUser.toMap(), "toUser": toUser.toMap()};
  }

  ChatInfo.fromJson(Map<String, dynamic> doc) {
    fromUser = UserData.fromJson(doc['fromUser'] as Map<String, dynamic>);
    toUser = UserData.fromJson(doc['toUser'] as Map<String, dynamic>);
  }

  String getChatId() {
    if (fromUser.id.hashCode <= toUser.id.hashCode) {
      return '${fromUser.id}_${toUser.id}';
    }
    return '${toUser.id}_${fromUser.id}';
  }
}
