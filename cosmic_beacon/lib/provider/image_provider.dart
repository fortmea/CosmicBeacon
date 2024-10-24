
import 'package:cosmic_beacon/data/api/imgws.dart';
import 'package:cosmic_beacon/extensions/language_extension.dart';
import 'package:cosmic_beacon/extras/utils.dart';
import 'package:cosmic_beacon/models/space_image.dart';
import 'package:cosmic_beacon/provider/container_height_provider.dart';
import 'package:cosmic_beacon/provider/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cosmic_beacon/extensions/string_extension.dart';

final iframeProvider = FutureProvider<WebViewController>((ref) async {
  final postId = ref.watch(postIdNotifierProvider);
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.transparent)
    ..enableZoom(false)
    ..addJavaScriptChannel('Twitter', onMessageReceived: (message) {
      ref
          .read(containerHeightProvider.notifier)
          .updateHeight(double.parse(message.message));
    })
    ..setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (request) {
        return NavigationDecision.prevent;
      },
    ));

  await controller.loadHtmlString(getHtmlString(postId!));
  return controller;
});

final imageProvider = FutureProvider.family<SpaceImage, bool?>(
  (ref, shouldTranslate) async {
    final apiProvider = ref.watch(imageApiProvider);
    final postIdProvider = ref.watch(postIdNotifierProvider.notifier);
    final img = SpaceImage.fromJson(await apiProvider.getImage());
    final uris = img.explanation!.extractUris();
    if (uris.isNotEmpty) {
      postIdProvider.updateId(extractTwitterId(
          (await apiProvider.getRedirectUrl(uris[0].toString())).toString()));
    }
    final locale = ref.watch(localeProvider);
    if (shouldTranslate == true && locale.languageCode != 'en') {
      final translator = OnDeviceTranslator(
          sourceLanguage: TranslateLanguage.english,
          targetLanguage: locale.toTranslateLanguage());

      img.title = await translator.translateText(img.title!);
      //img.explanation = await translator.translateText(img.explanation!);
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

final postIdNotifierProvider =
    StateNotifierProvider<PostIdNotifier, String?>((ref) {
  return PostIdNotifier();
});

// Define a notifier to manage state changes for the selected date
class PostIdNotifier extends StateNotifier<String?> {
  PostIdNotifier() : super(null);

  void updateId(String? newId) {
    state = newId;
  }
}
