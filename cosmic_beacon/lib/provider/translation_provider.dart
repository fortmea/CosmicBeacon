import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

final translationProvider =
    FutureProvider.family<String, Map<OnDeviceTranslator, String>>(
  (ref, map) async {
    return await map.keys.first.translateText(map.entries.first.value);
  },
);

final isDownloadedProvider = FutureProvider.family<bool, TranslateLanguage>(
  (ref, language) async {
    return await OnDeviceTranslatorModelManager()
        .isModelDownloaded(language.bcpCode);
  },
);



