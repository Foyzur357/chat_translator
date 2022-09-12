// import 'package:chat_translator/models/user.dart';
// import 'package:chat_translator/services/repository_service.dart';
// import 'package:flutter/material.dart';
//
// class PersonalInfoProvider extends ChangeNotifier {
//   final RepositoryService _repositoryService = RepositoryService();
//
//   bool _loading = true;
//   UserData? _userData;
//
//   bool get loading => _loading;
//   UserData? get userData => _userData;
//
//   set loading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }
//
//   set userData(UserData? userData) {
//     _userData = userData;
//     notifyListeners();
//   }
//
//   Future<void> setUserData(UserData userData) async {
//     await _repositoryService.setUserData(userData);
//     _loading = false;
//     notifyListeners();
//   }
//
//   Future<void> getUserData(String uid) async {
//     UserData? userData = await _repositoryService.getUserData(uid);
//     _userData = userData;
//     _loading = false;
//     notifyListeners();
//   }
// }
