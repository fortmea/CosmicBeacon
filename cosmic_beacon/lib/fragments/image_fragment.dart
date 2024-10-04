import 'package:cosmic_beacon/provider/image_provider.dart';
import 'package:cosmic_beacon/provider/translation_provider.dart';
import 'package:cosmic_beacon/widgets/list_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:localization/localization.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageFragment extends ConsumerWidget {
  const ImageFragment({super.key});

  @override
  Widget build(Object context, WidgetRef ref) {
    final OnDeviceTranslator onDeviceTranslator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english,
        targetLanguage: TranslateLanguage.portuguese);
    final image = ref.watch(imageProvider(true));
    final showMore = ref.watch(showMoreProvider);
    return Column(
      children: [
        const SizedBox(height: 32),
        Text(
          "image-of-the-day-text".i18n(),
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        Expanded(
            child: listFade(
                child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32),
              image.when(
                data: (data) {
                  return Column(children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: data.hdurl!,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    GlassContainer(
                      child: ListTile(
                        title: Text(data.title!),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GlassContainer(
                      child: ListTile(
                        title: Text("about".i18n()),
                        subtitle: Column(children: [
                          Text(showMore == false
                              ? '${data.explanation!.trim().substring(0, 150)}...'
                              : data.explanation!.trim()),
                          TextButton.icon(
                              onPressed: () {
                                showMore == false
                                    ? ref
                                        .read(showMoreProvider.notifier)
                                        .updateShowMore(true)
                                    : ref
                                        .read(showMoreProvider.notifier)
                                        .updateShowMore(false);
                              },
                              label: Text(showMore == false
                                  ? "more".i18n()
                                  : "less".i18n()),
                              icon: Icon(showMore == false
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_up_rounded)),
                        ]),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GlassContainer(
                      child: ListTile(
                        title: Text('copyright'.i18n()),
                        subtitle: Text(data.copyright!.trim()),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                  ]);
                },
                error: (error, stackTrace) {
                  print(error);
                  print(stackTrace);
                  return GlassContainer(
                    color: Colors.red.withOpacity(.2),
                    child: ListTile(
                      title: Text('error'.i18n()),
                      subtitle: Text("error-server-connection".i18n()),
                    ),
                  );
                },
                loading: () {
                  return const CircularProgressIndicator();
                },
              )
            ],
          ),
        )))
      ],
    );
  }
}
