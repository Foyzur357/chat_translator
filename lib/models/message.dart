// AuthService _authService = AuthService();

class Message {
  late String id;
  String? idFrom;
  String? idTo;
  int? type;
  String? contentLang;
  String? content;
  String? translationLang;
  String? translatedContent;
  String? timestamp;
  bool? show;

  Message({
    required this.id,
    this.idFrom,
    this.idTo,
    this.type,
    this.contentLang,
    this.content,
    this.translationLang,
    this.translatedContent,
    this.timestamp,
    this.show,
  });

  Message.fromJson(Map<String, dynamic>? doc, String messageId, String currentUserId) {
    id = messageId;
    idFrom = doc!['idFrom'] as String;
    idTo = doc['idTo'] as String;
    type = doc['type'] as int;
    contentLang = doc['contentLang'] as String;
    content = doc['content'] as String;
    translationLang = doc['translationLang'] as String?;
    translatedContent = doc['translatedContent'] as String?;
    timestamp = doc['timestamp'] as String;
    show = doc['${currentUserId}_showTrans'] != null ? doc['${currentUserId}_showTrans'] as bool : false;
  }
}
