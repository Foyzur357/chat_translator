import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_translator/components/default_container.dart';
import 'package:chat_translator/components/shimmers/chat_tile_shimmer.dart';
import 'package:chat_translator/models/chat_details.dart';
import 'package:chat_translator/models/user.dart';
import 'package:chat_translator/providers/auth_provider.dart';
import 'package:chat_translator/providers/chat_provider.dart';
import 'package:chat_translator/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatTile extends StatefulWidget {
  final ChatDetails item;
  const ChatTile({Key? key, required this.item}) : super(key: key);

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  late ChatProvider _chatProvider;
  late AuthProvider _authProvider;
  UserData? _otherUserData;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context);
    _chatProvider = Provider.of<ChatProvider>(context);
    List user = widget.item.users!.where((element) => element != _chatProvider.uid()).toList();
    getUserData(user[0]);
    // _chatInfo = ChatInfo(fromUser: _authProvider.userData!, toUser: _otherUserData!);
  }

  @override
  Widget build(BuildContext context) {
    if (_chatProvider.otherUserLoading) {
      return DefaultContainer(
        child: ChatTileShimmer(),
      );
    } else {
      return DefaultContainer(
        onTap: () {
          // ChatInfo chatInfo = ChatInfo(fromUser: _authProvider.userData!, toUser: _otherUserData!);
          //
          // Navigator.pushNamed(context, Routes.getChatScreenRoute(chatInfo.toUser.id ?? ""), arguments: chatInfo.toMap());
        },
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primaryColor,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: "https://picsum.photos/200",
                  fit: BoxFit.cover,
                  width: 48,
                  height: 48,
                ),
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    // searchResults[index].name,
                    _otherUserData?.name ?? "Name",
                    style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    // "Native: ${searchResults[index].nativeLanguage}",
                    widget.item.lastMessage ?? "Start chat",
                    style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
  }

  void getUserData(String uid) async {
    _otherUserData = await _chatProvider.getOtherUserData(uid);
  }
}
