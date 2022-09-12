class Routes {
  static String AUTH_WRAPPER = "/";

  static String HOME_SCREEN = "/chat-list";
  static String SEARCH_SCREEN = "/search";
  static String PROFILE_SCREEN = "/profile";
  static String EDIT_PROFILE_SCREEN = "/edit-profile";
  static String OTHERS_PROFILE_SCREEN = "/others-profile";
  static String CHAT_SCREEN = "/chat";

  static String SPLASH_SCREEN = "/splash";
  static String SIGN_IN_SCREEN = "/sign-in";
  static String SIGN_UP_SCREEN = "/sign-up";
  static String VERIFY_SCREEN = "/verify";
  static String PERSONAL_INFO_SCREEN = "/personal-info";

  //methods to pass parameters

  static String getOthersProfileScreenRoute(String uid) {
    return "$OTHERS_PROFILE_SCREEN?uid=$uid";
  }

  static String getChatScreenRoute(String uid) {
    return "$CHAT_SCREEN?uid=$uid";
  }
}
