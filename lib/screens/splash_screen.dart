import 'package:chat_translator/utils/color_const.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // void checkState() async {
  //   AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   bool isLoggedIn = await authProvider.isUserSignedIn();
  //   bool isVerified = await authProvider.isVerified();
  //
  //   if (isLoggedIn) {
  //     if (isVerified) {
  //       authProvider.getUserData(authProvider.uid() ?? "");
  //       UserData? userData = authProvider.userData;
  //       if (userData == null) {
  //         Navigator.pushReplacementNamed(context, Routes.PERSONAL_INFO_SCREEN);
  //       }
  //       Navigator.pushReplacementNamed(context, Routes.HOME_SCREEN);
  //     } else {
  //       Navigator.pushReplacementNamed(context, Routes.VERIFY_SCREEN);
  //     }
  //   } else {
  //     Navigator.pushReplacementNamed(context, Routes.SIGN_IN_SCREEN);
  //   }
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(Duration(seconds: 3), () {
  //     checkState();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Icon(
          Icons.ac_unit_outlined,
          size: 56,
          color: kBrandGreen,
        ),
      ),
    );
  }
}
