import 'package:chat_translator/chat_translator_app.dart';
import 'package:chat_translator/models/chat_info.dart';
import 'package:chat_translator/router/routes.dart';
import 'package:chat_translator/screens/chat_screen.dart';
import 'package:chat_translator/screens/edit_profile_screen.dart';
import 'package:chat_translator/screens/home_screen.dart';
import 'package:chat_translator/screens/others_profile_screen.dart';
import 'package:chat_translator/screens/profile_screen.dart';
import 'package:chat_translator/screens/search_screen.dart';
import 'package:chat_translator/screens/sign_in_screen.dart';
import 'package:chat_translator/screens/signup_journey/personal_info_screen.dart';
import 'package:chat_translator/screens/signup_journey/sign_up_screen.dart';
import 'package:chat_translator/screens/signup_journey/verify_screen.dart';
import 'package:chat_translator/screens/splash_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class RouterHelper {
  static final FluroRouter router = FluroRouter();

  static final Handler _authWrapperHandler = Handler(handlerFunc: (context, parameters) => const AuthenticationWrapper());

  static final Handler _splashScreenHandler = Handler(handlerFunc: (context, parameters) => SplashScreen());

  //account
  static final Handler _signInScreenHandler = Handler(handlerFunc: (context, parameters) => SignInScreen());
  static final Handler _signUpScreenHandler = Handler(handlerFunc: (context, parameters) => SignUpScreen());
  static final Handler _verifyScreenHandler = Handler(handlerFunc: (context, parameters) => VerifyScreen());
  static final Handler _personalInfoScreenHandler = Handler(handlerFunc: (context, parameters) => PersonalInfoScreen());
  static final Handler _chatScreenHandler = Handler(handlerFunc: (context, parameters) {
    final args = ModalRoute.of(context!)?.settings.arguments as Map<String, dynamic>;
    return ChatScreen(chatInfo: ChatInfo.fromJson(args));
  });

  static final Handler _homeScreenHandler = Handler(handlerFunc: (context, parameters) => HomeScreen());
  static final Handler _searchScreenHandler = Handler(handlerFunc: (context, parameters) => SearchScreen());
  static final Handler _profileScreenHandler = Handler(handlerFunc: (context, parameters) => ProfileScreen());
  static final Handler _othersProfileScreenHandler = Handler(handlerFunc: (context, parameters) => OthersProfileScreen(uid: parameters["uid"]![0]));
  static final Handler _editProfileScreenHandler = Handler(handlerFunc: (context, parameters) => EditProfileScreen());

  static final Handler _notFoundHandler = Handler(handlerFunc: (context, parameters) {
    print("No Router Found!");
    return null;
  });
  void setupRouter() {
    //account
    router.define(
      Routes.AUTH_WRAPPER,
      handler: _authWrapperHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      Routes.SPLASH_SCREEN,
      handler: _splashScreenHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      Routes.SIGN_IN_SCREEN,
      handler: _signInScreenHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      Routes.SIGN_UP_SCREEN,
      handler: _signUpScreenHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      Routes.VERIFY_SCREEN,
      handler: _verifyScreenHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      Routes.PERSONAL_INFO_SCREEN,
      handler: _personalInfoScreenHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      Routes.HOME_SCREEN,
      handler: _homeScreenHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      Routes.SEARCH_SCREEN,
      handler: _searchScreenHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      Routes.PROFILE_SCREEN,
      handler: _profileScreenHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      Routes.EDIT_PROFILE_SCREEN,
      handler: _editProfileScreenHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      Routes.OTHERS_PROFILE_SCREEN,
      handler: _othersProfileScreenHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      Routes.CHAT_SCREEN,
      handler: _chatScreenHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.notFoundHandler = _notFoundHandler;
  }
}
