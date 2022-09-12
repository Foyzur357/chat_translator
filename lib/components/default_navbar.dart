import 'package:chat_translator/providers/auth_provider.dart';
import 'package:chat_translator/router/routes.dart';
import 'package:chat_translator/utils/color_const.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DefaultNavBar extends StatelessWidget {
  // final Function onTap;
  final int initialActiveIndex;
  const DefaultNavBar({
    Key? key,
    required this.initialActiveIndex,
    // required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return ConvexAppBar(
      initialActiveIndex: initialActiveIndex,
      onTap: (int i) {
        if (initialActiveIndex == i) {
          return;
        }
        switch (i) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(context, Routes.HOME_SCREEN, (params) => false);
            break;
          case 1:
            Navigator.pushNamedAndRemoveUntil(context, Routes.SEARCH_SCREEN, (params) => false);
            break;
          case 2:
            Navigator.pushNamedAndRemoveUntil(context, Routes.PROFILE_SCREEN, (params) => false);
            break;
          default:
            print(i);
        }
      },
      backgroundColor: AppColors.primaryColor,
      style: TabStyle.textIn,
      items: [
        TabItem(
          icon: Icons.chat_rounded,
          title: "Messages",
        ),
        TabItem(
          icon: Icons.search,
          title: "Search",
        ),
        TabItem(
          icon: Icons.person_outline_rounded,
          title: "Profile",
        ),
      ],
    );
  }
}
