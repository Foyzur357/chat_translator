import 'dart:convert';

import 'package:chat_translator/exceptions/exception.dart';
import 'package:chat_translator/models/translation.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:selection_dialogs/language_convert.dart';

class TranslateUtils {
  static const _apiKey = 'AIzaSyAjYUoKhxXPFGBBKOdceeiBKI_X0wBpGSM';

  static Future<TranslationBody> translate(String message, String targetLanguage) async {
    // String learningLangCode = LanguageConvert().nameToCode(friendNativeLanguage);
    String targetLanguageCode = LanguageConvert().nameToCode(targetLanguage);

    TranslationBody translationBody = await _translateApiResponse(targetLanguageCode, message);
    // if (translationBody.inputLang != null) {
    //   if (translationBody.inputLang != learningLangCode) {
    //     translationBody = await _translateApiResponse(learningLangCode, message);
    //   }
    // }
    return translationBody;
  }

  static Future<TranslationBody> _translateApiResponse(String targetLanguage, String message) async {
    final response = await http.post(Uri.parse(
      'https://translation.googleapis.com/language/translate/v2?target=$targetLanguage&key=$_apiKey&q=$message',
    ));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final translations = body['data']['translations'] as List;
      final translation = translations.first;

      return TranslationBody(
          translatedBody: HtmlUnescape().convert(translation['translatedText'] as String),
          inputLang: HtmlUnescape().convert(translation['detectedSourceLanguage'] as String),
          outputLang: targetLanguage);
    } else {
      throw TranslationException("error while translating with Google Translation API");
    }
  }

  static Future<String> detect(String message) async {
    final response = await http.post(Uri.parse(
      'https://translation.googleapis.com/language/translate/v2/detect?target=key=$_apiKey&q=$message',
    ));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final detections = body['data']['detections'] as List;
      final detection = (detections.first as List).first;

      return HtmlUnescape().convert(detection['language'] as String);
    } else {
      throw Exception();
    }
  }
}
