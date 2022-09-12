mixin InputValidationMixin {
  bool isValidName(String name) {
    RegExp regex = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return regex.hasMatch(name);
  }

  bool isEmailValid(String email) {
    RegExp regex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
    return regex.hasMatch(password);
  }

  bool isNotEmpty(String string) => string.isNotEmpty;

  bool isValidPhone(String phone) {
    RegExp regex = RegExp(r"^\+?0[0-9]{10}$");
    return regex.hasMatch(phone);
  }
}
