import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_translator/components/animations/loading_animation.dart';
import 'package:chat_translator/components/default_container.dart';
import 'package:chat_translator/models/chat_info.dart';
import 'package:chat_translator/providers/auth_provider.dart';
import 'package:chat_translator/providers/chat_provider.dart';
import 'package:chat_translator/router/routes.dart';
import 'package:chat_translator/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OthersProfileScreen extends StatelessWidget {
  final String uid;
  const OthersProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);

    authProvider.getOtherUserData(uid);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // shadowColor: Colors.grey.withOpacity(0.2),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.grey),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: authProvider.otherUserLoading
            ? Center(
                child: Loader(),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DefaultContainer(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.primaryColor,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: "https://picsum.photos/200",
                                fit: BoxFit.cover,
                                width: 56,
                                height: 56,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 6.h,
                              ),
                              Text(
                                authProvider.otherUserData?.name ?? "",
                                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Text(
                                authProvider.otherUserData?.email ?? "",
                                style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Text(
                                authProvider.otherUserData?.bio ?? "",
                                style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    DefaultContainer(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Date of Birth",
                                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  DateFormat('dd MMMM, yyyy').format(authProvider.otherUserData?.birthDate ?? DateTime.now()),
                                  style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Gender",
                                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  authProvider.otherUserData?.gender ?? "",
                                  style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    DefaultContainer(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Native",
                                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  authProvider.otherUserData?.nativeLanguage ?? "",
                                  style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Learning",
                                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  authProvider.otherUserData?.learningLanguage ?? "",
                                  style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    DefaultContainer(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Country",
                                style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
                              ),
                              Text(
                                authProvider.otherUserData?.country ?? "",
                                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    DefaultContainer(
                      onTap: () async {
                        ChatInfo chatInfo = ChatInfo(fromUser: authProvider.userData!, toUser: authProvider.otherUserData!);
                        bool docExists = await chatProvider.checkDocExists(chatInfo.getChatId());
                        if (!docExists) {
                          chatProvider.createChat(chatInfo);
                        }
                        Navigator.pushNamed(context, Routes.getChatScreenRoute(chatInfo.toUser.id), arguments: chatInfo.toMap());
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatInfo: chatInfo.toMap())));
                      },
                      padding: EdgeInsets.all(16),
                      color: AppColors.primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Start Chat",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
