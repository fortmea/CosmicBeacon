import 'package:cosmic_beacon/extensions/Image_provider_extension.dart';
import 'package:cosmic_beacon/provider/image_provider.dart';
import 'package:cosmic_beacon/provider/locale_provider.dart';
import 'package:cosmic_beacon/widgets/glowing_widget.dart';
import 'package:cosmic_beacon/widgets/list_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:localization/localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ImageFragment extends ConsumerWidget {
  const ImageFragment({super.key});

  @override
  Widget build(Object context, WidgetRef ref) {
    WidgetsToImageController controller = WidgetsToImageController();
    final image = ref.watch(imageProvider(true));
    final showMore = ref.watch(showMoreProvider);
    final locale = ref.watch(localeProvider);
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
                        child: Stack(children: [
                          WidgetsToImage(
                              controller: controller,
                              child: CachedNetworkImage(
                                imageUrl: data.hdurl!,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )),
                          IconButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ))),
                              icon: const Icon(Icons.share_rounded),
                              onPressed: () async {
                                await controller.capture().then((value) {
                                  Share.shareXFiles(
                                    [
                                      XFile.fromData(value!,
                                          name: 'share.jpg',
                                          mimeType: 'image/jpeg',
                                          lastModified: DateTime.now())
                                    ],
                                    text: 'image-of-the-day-text'.i18n(),
                                  );
                                });
                              }),
                        ])),
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
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("about".i18n()),
                              locale.languageCode != 'en'
                                  ? TextButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white.withOpacity(.1)),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ))),
                                      onPressed: () {
                                        showDialog(
                                            context: context as BuildContext,
                                            builder: (context) {
                                              return Dialog(
                                                  child: GlowingWidget(
                                                      style: PaintingStyle.fill,
                                                      opacity: .9,
                                                      child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8),
                                                                topRight: Radius
                                                                    .circular(
                                                                        8)),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                                children: [
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(1),
                                                                          borderRadius: BorderRadius.circular(8),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                color: Colors.white.withOpacity(.1),
                                                                                blurRadius: 8,
                                                                                spreadRadius: 4)
                                                                          ]),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            16),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Text("about-translation".i18n(),
                                                                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                            const Divider(),
                                                                            Text("about-translation-text".i18n([
                                                                              locale.languageCode
                                                                            ]))
                                                                          ],
                                                                        ),
                                                                      )),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      TextButton(
                                                                          style:
                                                                              ButtonStyle(
                                                                            shape:
                                                                                MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(Colors.black.withOpacity(1)),
                                                                            foregroundColor:
                                                                                MaterialStateProperty.all(Colors.white),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "ok".i18n(),
                                                                          ))
                                                                    ],
                                                                  )
                                                                ]),
                                                          ))));
                                            });
                                      },
                                      icon: const Icon(Icons.translate),
                                      label: Text("about-translation".i18n()))
                                  : Container()
                            ]),
                        subtitle: Column(children: [
                          Text(showMore == false
                              ? '${data.explanation!.trim().substring(0, 150)}...'
                              : data.explanation!.trim()),
                          TextButton.icon(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ))),
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
