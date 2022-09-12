import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_translator/components/default_container.dart';
import 'package:chat_translator/components/default_navbar.dart';
import 'package:chat_translator/components/shimmers/chat_tile_shimmer.dart';
import 'package:chat_translator/models/chat_details.dart';
import 'package:chat_translator/models/chat_info.dart';
import 'package:chat_translator/models/user.dart';
import 'package:chat_translator/providers/auth_provider.dart';
import 'package:chat_translator/providers/chat_provider.dart';
import 'package:chat_translator/router/routes.dart';
import 'package:chat_translator/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChatProvider>(context, listen: false).getChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          "Chat Translator",
          style: TextStyle(color: AppColors.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: chatProvider.chats.length,
                itemBuilder: (context, index) {
                  ChatDetails item = chatProvider.chats[index];
                  List user = item.users!.where((element) => element != Provider.of<AuthProvider>(context, listen: false).uid()).toList();

                  return FutureBuilder<ChatInfo>(
                      future: _getChatInfo(Provider.of<AuthProvider>(context, listen: false), chatProvider, user[0]),
                      builder: (context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const DefaultContainer(
                              child: ChatTileShimmer(),
                            );
                          default:
                            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                            if (snapshot.hasData) {
                              ChatInfo? chatInfo = snapshot.data;
                              return DefaultContainer(
                                onTap: () {
                                  Navigator.pushNamed(context, Routes.getChatScreenRoute(chatInfo?.toUser.id ?? ""), arguments: chatInfo?.toMap());
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
                                            chatInfo?.toUser.name ?? "Name",
                                            style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 6.h,
                                          ),
                                          Text(
                                            // "Native: ${searchResults[index].nativeLanguage}",
                                            item.lastMessage ?? "Start chat",
                                            style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else
                              return Text('Result: ${snapshot.data}');
                        }
                        // if (snapshot.hasData) {
                        //   ChatInfo? chatInfo = snapshot.data;
                        //   return DefaultContainer(
                        //     onTap: () {
                        //       Navigator.pushNamed(context, Routes.getChatScreenRoute(chatInfo?.toUser.id ?? ""), arguments: chatInfo?.toMap());
                        //     },
                        //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        //     child: Row(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         CircleAvatar(
                        //           radius: 26,
                        //           backgroundColor: AppColors.primaryColor,
                        //           child: ClipOval(
                        //             child: CachedNetworkImage(
                        //               imageUrl: "https://picsum.photos/200",
                        //               fit: BoxFit.cover,
                        //               width: 48,
                        //               height: 48,
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           width: 12.w,
                        //         ),
                        //         Expanded(
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             // mainAxisSize: MainAxisSize.min,
                        //             children: [
                        //               SizedBox(
                        //                 height: 6.h,
                        //               ),
                        //               Text(
                        //                 // searchResults[index].name,
                        //                 chatInfo?.toUser.name ?? "Name",
                        //                 style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                        //               ),
                        //               SizedBox(
                        //                 height: 6.h,
                        //               ),
                        //               Text(
                        //                 // "Native: ${searchResults[index].nativeLanguage}",
                        //                 item.lastMessage ?? "Start chat",
                        //                 style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
                        //                 maxLines: 1,
                        //                 overflow: TextOverflow.ellipsis,
                        //               ),
                        //             ],
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   );
                        // }
                        // return const DefaultContainer(
                        //   child: ChatTileShimmer(),
                        // );
                      });
                }),
          );
        },
      ),
      bottomNavigationBar: const DefaultNavBar(
        initialActiveIndex: 0,
      ),
    );
  }
}

Future<ChatInfo> _getChatInfo(AuthProvider authProvider, ChatProvider chatProvider, String user) async {
  UserData? otherUserData = await chatProvider.getOtherUserData(user);
  return ChatInfo(fromUser: authProvider.userData!, toUser: otherUserData!);
}
