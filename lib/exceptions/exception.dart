class AuthException implements Exception {
  String cause;
  AuthException(this.cause);
}

class TranslationException implements Exception {
  String cause;
  TranslationException(this.cause);
}
