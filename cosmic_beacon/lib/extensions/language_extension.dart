import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

extension LanguageExtension on Locale {
  TranslateLanguage toTranslateLanguage() {
    switch (this) {
      case Locale(languageCode: 'en'):
        return TranslateLanguage.english;
      case Locale(languageCode: 'pt'):
        return TranslateLanguage.portuguese;
      case Locale(languageCode: 'es'):
        return TranslateLanguage.spanish;
      case Locale(languageCode: 'it'):
        return TranslateLanguage.italian;
      case Locale(languageCode: 'fr'):
        return TranslateLanguage.french;
      case Locale(languageCode: 'de'):
        return TranslateLanguage.german;
      default:
        return TranslateLanguage.english;
    }
  }
}
