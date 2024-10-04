import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

extension LanguageExtension on Locale {
  TranslateLanguage toTranslateLanguage() {
    switch (this) {
      case Locale(languageCode: 'en'):
        return TranslateLanguage.english;
      case Locale(languageCode: 'pt'):
        return TranslateLanguage.portuguese;
      default:
        return TranslateLanguage.english;
    }
  }
}
