import 'package:chat_translator/components/animations/loading_animation.dart';
import 'package:chat_translator/models/user.dart';
import 'package:chat_translator/providers/auth_provider.dart';
import 'package:chat_translator/router/router_helper.dart';
import 'package:chat_translator/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatTranslatorApp extends StatefulWidget {
  const ChatTranslatorApp({Key? key}) : super(key: key);

  @override
  State<ChatTranslatorApp> createState() => _ChatTranslatorAppState();
}

class _ChatTranslatorAppState extends State<ChatTranslatorApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RouterHelper().setupRouter();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat Translator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthenticationWrapper(),
        onGenerateRoute: RouterHelper.router.generator,
        initialRoute: Routes.SPLASH_SCREEN,
      ),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  void checkState() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool isLoggedIn = await authProvider.isUserSignedIn();
    bool isVerified = await authProvider.isVerified();

    if (isLoggedIn) {
      if (isVerified) {
        await authProvider.getCurrentUserData();
        UserData? userData = authProvider.userData;
        if (userData == null) {
          Navigator.pushReplacementNamed(context, Routes.PERSONAL_INFO_SCREEN);
        } else {
          Navigator.pushReplacementNamed(context, Routes.HOME_SCREEN);
        }
      } else {
        Navigator.pushReplacementNamed(context, Routes.VERIFY_SCREEN);
      }
    } else {
      Navigator.pushReplacementNamed(context, Routes.SIGN_IN_SCREEN);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      checkState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Loader(),
      ),
    );
  }
}
