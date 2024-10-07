import 'package:cosmic_beacon/data/api/imgws.dart';
import 'package:cosmic_beacon/extensions/language_extension.dart';
import 'package:cosmic_beacon/models/space_image.dart';
import 'package:cosmic_beacon/provider/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

final imageProvider = FutureProvider.family<SpaceImage, bool?>(
  (ref, shouldTranslate) async {
    final img =
        SpaceImage.fromJson(await ref.watch(imageApiProvider).getImage());

    final locale = ref.watch(localeProvider);
    if (shouldTranslate == true && locale.languageCode != 'en') {
      final translator = OnDeviceTranslator(
          sourceLanguage: TranslateLanguage.english,
          targetLanguage: locale.toTranslateLanguage());

      img.title = await translator.translateText(img.title!);
      img.explanation = await translator.translateText(img.explanation!);
    }

    return img;
  },
);
// Define a provider to manage the selected date
final showMoreProvider = StateNotifierProvider<ShowMoreNotifier, bool?>((ref) {
  return ShowMoreNotifier();
});

// Define a notifier to manage state changes for the selected date
class ShowMoreNotifier extends StateNotifier<bool?> {
  ShowMoreNotifier() : super(false);

  void updateShowMore(bool? newBool) {
    state = newBool;
  }
}
