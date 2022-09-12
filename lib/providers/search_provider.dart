import 'package:chat_translator/models/search_result.dart';
import 'package:chat_translator/services/auth_service.dart';
import 'package:chat_translator/services/repository_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class SearchProvider with ChangeNotifier {
  final RepositoryService _repositoryService = RepositoryService();
  final AuthService _authService = AuthService();

  bool _loading = false;
  bool _showSearchOptions = true;
  bool _optionsSelected = false;
  bool _showSearchResults = false;

  Map<String, dynamic> _searchParameters = {
    "gender": "",
    "native_lang": "",
    "learning_lang": "",
    "country": "",
  };

  List<SearchResultObject> _searchResultList = [];

  bool get loading => _loading;

  bool get showSearchOptions => _showSearchOptions;

  bool get optionsSelected => _optionsSelected;

  bool get showSearchResults => _showSearchResults;

  Map<String, dynamic> get searchParameters => _searchParameters;

  List<SearchResultObject> get searchResultList => _searchResultList;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  set showSearchOptions(bool value) {
    _showSearchOptions = value;
    notifyListeners();
  }

  set optionsSelected(bool value) {
    _optionsSelected = value;
    notifyListeners();
  }

  set showSearchResults(bool value) {
    _showSearchResults = value;
    notifyListeners();
  }

  set searchParameters(Map<String, dynamic> updateData) {
    updateData.forEach((key, data) {
      _searchParameters.update(key, (value) => data);

      if (data != "") {
        _optionsSelected = true;
      }
    });
    notifyListeners();
  }

  Future<void> performSearch() async {
    List<DocumentSnapshot> results = await _repositoryService.performSearch(_searchParameters);

    List<SearchResultObject> resultList = [];

    for (final searchResult in results) {
      final String _resultUserId = searchResult['id'] as String;

      if (_authService.uid() == _resultUserId) {
        continue;
      }

      try {
        resultList.add(
          SearchResultObject(
            name: searchResult["name"] as String,
            userId: _resultUserId,
            // avatar: searchResult["avatar"] as String,
            nativeLanguage: searchResult["nativeLanguage"] as String,
            learningLanguage: searchResult["learningLanguage"] as String,
          ),
        );
      } catch (e) {
        print(e);
        debugPrint('[- fail ]>>>>>>$_resultUserId');
      }
    }
    _searchResultList = resultList;
    notifyListeners();
  }
}
