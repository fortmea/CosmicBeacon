import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

extension LanguageExtension on Locale {
  TranslateLanguage toTranslateLanguage() {
    switch (languageCode) {
      case 'en':
        return TranslateLanguage.english;
      case 'pt':
        return TranslateLanguage.portuguese;
      case 'es':
        return TranslateLanguage.spanish;
      case 'it':
        return TranslateLanguage.italian;
      case 'fr':
        return TranslateLanguage.french;
      case 'de':
        return TranslateLanguage.german;
      default:
        return TranslateLanguage.english;
    }
  }
}
