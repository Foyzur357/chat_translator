import 'package:chat_translator/components/app_text_field.dart';
import 'package:chat_translator/components/default_container.dart';
import 'package:chat_translator/models/chat_info.dart';
import 'package:chat_translator/models/message.dart';
import 'package:chat_translator/providers/chat_provider.dart';
import 'package:chat_translator/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final ChatInfo chatInfo;
  ChatScreen({Key? key, required this.chatInfo}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChatProvider>(context, listen: false).getMessages(widget.chatInfo);
      Provider.of<ChatProvider>(context, listen: false).getEncryptionKey(widget.chatInfo.getChatId());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return _buildBody(chatProvider);
        },
      ),
    );
  }

  Center _buildBody(ChatProvider chatProvider) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: chatProvider.messages.length,
                itemBuilder: (context, index) {
                  Message item = chatProvider.messages[index];
                  String message = chatProvider.decryptMsg(item.content ?? "", chatProvider.key);
                  bool sendByMe = chatProvider.sendByMe(item.idFrom ?? "");
                  return AnimatedContainer(
                    padding: const EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    child: GestureDetector(
                      onDoubleTap: () {
                        String? targetLanguage = sendByMe ? widget.chatInfo.toUser.nativeLanguage : widget.chatInfo.fromUser.nativeLanguage;
                        chatProvider.translate(
                            message: message,
                            chatId: widget.chatInfo.getChatId(),
                            messageId: item.id,
                            targetLanguage: targetLanguage ?? "English",
                            encryptionKey: chatProvider.key);
                      },
                      child: Column(
                        crossAxisAlignment: sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Container(
                            // width: item.translationLang ? 200.0 : 100.0,
                            // height: selected ? 100.0 : 200.0,
                            // color: selected ? Colors.red : Colors.blue,
                            decoration: BoxDecoration(
                              borderRadius: item.show!
                                  ? BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                                  : BorderRadius.circular(20),
                              color: sendByMe ? Colors.grey.shade200 : Colors.blue[200],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Text(message),
                          ),
                          if (item.show!)
                            GestureDetector(
                              onTap: () {
                                chatProvider.closeTranslation(chatId: widget.chatInfo.getChatId(), messageId: item.id);
                              },
                              child: Container(
                                // width: item.translationLang ? 200.0 : 100.0,
                                // height: selected ? 100.0 : 200.0,
                                // color: selected ? Colors.red : Colors.blue,
                                decoration: BoxDecoration(
                                  borderRadius: item.show!
                                      ? BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                                      : BorderRadius.circular(20),
                                  color: sendByMe ? Colors.blue[200] : Colors.grey.shade200,
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  chatProvider.decryptMsg(item.translatedContent ?? "", chatProvider.key),
                                ),
                              ),
                            )
                          else
                            Container(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ChatInputModule(
              chatInfo: widget.chatInfo,
              messageController: messageController,
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 4,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primaryColor,
                ),
              ),
              CircleAvatar(
                backgroundImage: NetworkImage("https://picsum.photos/200"),
                maxRadius: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.chatInfo.toUser.name ?? "",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      widget.chatInfo.toUser.nativeLanguage ?? "",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              // Icon(
              //   Icons.settings,
              //   color: Colors.black54,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatInputModule extends StatelessWidget {
  const ChatInputModule({
    Key? key,
    required this.chatInfo,
    required this.messageController,
  }) : super(key: key);

  final ChatInfo chatInfo;
  final TextEditingController messageController;
  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);

    return DefaultContainer(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextInputField(
              controller: messageController,
              label: '',
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          DefaultContainer(
            onTap: () {
              String content = messageController.text;
              chatProvider.sendMessage(chatInfo, content, 1);
              messageController.clear();
            },
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.send_rounded,
              color: AppColors.primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
