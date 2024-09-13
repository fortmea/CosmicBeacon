import 'dart:io';

import 'package:cosmic_beacon/data/firebase/firebase_database.dart';
import 'package:cosmic_beacon/extras/theming.dart';
import 'package:cosmic_beacon/extras/utils.dart';
import 'package:cosmic_beacon/models/asteroid_data.dart';
import 'package:cosmic_beacon/models/insight.dart';
import 'package:cosmic_beacon/models/shooting_stars.dart';
import 'package:cosmic_beacon/provider/ai_insight_provider.dart';
import 'package:cosmic_beacon/provider/bookmarked_provider.dart';
import 'package:cosmic_beacon/provider/locale_provider.dart';
import 'package:cosmic_beacon/provider/neo_provider.dart';
import 'package:cosmic_beacon/widgets/approach_date.dart';
import 'package:cosmic_beacon/widgets/cycling_text.dart';
import 'package:cosmic_beacon/widgets/glowing_widget.dart';
import 'package:cosmic_beacon/widgets/list_fade.dart';
import 'package:cosmic_beacon/widgets/neo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:localization/localization.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class NeoFull extends ConsumerStatefulWidget {
  final AsteroidData asteroidData;
  final bool bookmarked;
  const NeoFull({
    super.key,
    required this.asteroidData,
    this.bookmarked = false,
  });

  @override
  ConsumerState<NeoFull> createState() => _NeoFull();
}

@override
class _NeoFull extends ConsumerState<NeoFull> {
  MeasurementUnits preferedMeasurementUnit = MeasurementUnits.kilometers;
  WidgetsToImageController controller = WidgetsToImageController();
  File? file3d;
  void load3d() async {
    var dir = await getApplicationDocumentsDirectory();

    var byteData = await rootBundle.load('lib/res/compressed/3d/a3.glb.gz');
    var bytes = byteData.buffer.asUint8List();
    var gzipBytes = gzip.decode(bytes);

    file3d = File('${dir.path}/a3.glb');
    file3d!.writeAsBytesSync(gzipBytes);
    setState(() {
      file3d = File('file://${dir.path}/a3.glb');
    });
  }

  @override
  void initState() {
    load3d();
    Future.delayed(const Duration(milliseconds: 100), () async {
      ref.read(bookmarkedProvider.notifier).updateBookmarked(widget.bookmarked);

      try {
        loadAd();
        showAd();
      } catch (e) {
        print(e);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(neoDetailedDataProvider(widget.asteroidData.id));
    final bookmark = ref.watch(bookmarkedProvider);
    final localeProviderRef = ref.watch(localeProvider);
    final localizator = InsightLocalizator(
        localeProviderRef.languageCode, widget.asteroidData.id);

    final distanceList = widget
        .asteroidData.closeApproachDataList[0].missDistance
        .toJson()
        .entries
        .toList();
    //print(insight.value);
    return Scaffold(
        appBar: AppBar(
            forceMaterialTransparency: true,
            actions: [
              (FirebaseAuth.instance.currentUser != null)
                  ? IconButton(
                      icon: Icon(
                          (bookmark) ? Icons.bookmark : Icons.bookmark_border),
                      onPressed: () {
                        Database(uid: FirebaseAuth.instance.currentUser!.uid)
                            .addBookmark(widget.asteroidData.id);
                        ref
                            .read(bookmarkedProvider.notifier)
                            .updateBookmarked(!bookmark);
                      },
                    )
                  : const SizedBox(),
              IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return Dialog(
                              insetPadding: const EdgeInsets.all(16.0),
                              backgroundColor: meuTema.scaffoldBackgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: Text('preview'.i18n(),
                                          style: const TextStyle(fontSize: 18)),
                                      leading:
                                          const Icon(Icons.preview_outlined),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    WidgetsToImage(
                                        controller: controller,
                                        child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                color: meuTema
                                                    .scaffoldBackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Neo(
                                                asteroidData:
                                                    widget.asteroidData,
                                                isModelViewerVisible: true,
                                                preferedMeasurementUnit:
                                                    preferedMeasurementUnit,
                                                onTap: () {}))),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          DropdownMenu(
                                            label: Text(
                                                'select-measurement'.i18n()),
                                            initialSelection:
                                                preferedMeasurementUnit,
                                            onSelected: (value) {
                                              setState(() {
                                                preferedMeasurementUnit =
                                                    value as MeasurementUnits;
                                              });
                                            },
                                            dropdownMenuEntries: <DropdownMenuEntry<
                                                MeasurementUnits>>[
                                              for (var item
                                                  in MeasurementUnits.values)
                                                DropdownMenuEntry<
                                                    MeasurementUnits>(
                                                  value: item,
                                                  label:
                                                      ("p-${item.toString().split('.').last}")
                                                          .i18n(),
                                                ),
                                            ],
                                          )
                                        ]),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () async {
                                              await controller.capture().then(
                                                (value) {
                                                  Share.shareXFiles(
                                                    [
                                                      XFile.fromData(value!,
                                                          name: 'neo-share.jpg',
                                                          mimeType:
                                                              'image/jpeg',
                                                          lastModified:
                                                              DateTime.now())
                                                    ],
                                                    text: 'neo-share-text'
                                                        .i18n([
                                                      widget.asteroidData.name
                                                          .split("(")[1]
                                                          .split(")")[0]
                                                    ]),
                                                  );
                                                },
                                              );
                                            },
                                            child: Text('share'.i18n()),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('close'.i18n()),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ));
                        });
                      },
                    );
                  },
                  icon: const Icon(Icons.share))
            ],
            title: Text(
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                widget.asteroidData.name.split("(")[1].split(")")[0])),
        body: Stack(children: [
          const ShootingStarsBackground(),
          listFade(child: LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                        child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(children: [
                        Expanded(
                            child: Column(
                          children: [
                            SizedBox(
                                height: 128,
                                child: file3d != null
                                    ? ModelViewer(
                                        backgroundColor: Colors.transparent,
                                        src: file3d!.path,
                                        alt: 'neo-alt-text'.i18n(),
                                        shadowIntensity: 1,
                                        disablePan: true,
                                        disableTap: true,
                                        cameraControls: false,
                                        shadowSoftness: 1,
                                        debugLogging: false,
                                        autoRotate: true,
                                        disableZoom: true,
                                        touchAction: TouchAction.none,
                                        interactionPrompt:
                                            InteractionPrompt.none,
                                      )
                                    : const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      )),
                            Expanded(
                              child: Row(children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "neo-size".i18n([
                                          '${widget.asteroidData.estimatedDiameterKm['min']!.toStringAsFixed(2)} km',
                                          '${widget.asteroidData.estimatedDiameterKm['max']!.toStringAsFixed(2)} km'
                                        ]),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'neo-approach-date'.i18n([
                                          DateFormat.yMd(Platform.localeName)
                                              .add_jm()
                                              .format(parseCustomDate(widget
                                                  .asteroidData
                                                  .closeApproachDataList[0]
                                                  .closeApproachDateFull))
                                        ]),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'neo-hazardous'.i18n([], [
                                          widget.asteroidData
                                              .isPotentiallyHazardous
                                        ]),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'neo-orbiting-body'.i18n([
                                          widget
                                              .asteroidData
                                              .closeApproachDataList[0]
                                              .orbitingBody
                                              .i18n()
                                        ]),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'distance'.i18n(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          FadingTextCycleWidget(
                                              duration:
                                                  const Duration(seconds: 3),
                                              texts: distanceList.map((e) {
                                                return e.key.i18n([
                                                  NumberFormat.decimalPattern(
                                                          Platform.localeName)
                                                      .format(
                                                          double.parse(e.value))
                                                ]);
                                              }).toList())
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      StreamBuilder(
                                        stream: Database(uid: "0")
                                            .generationRequest(localizator),
                                        builder: (context, snapshot) {
                                          if (snapshot.error != null) {
                                            return Text(
                                                snapshot.error.toString());
                                          }
                                          if (snapshot.hasData) {
                                            final data = snapshot.data.data();
                                            if (data != null) {
                                              final insight = Insight.fromJson(
                                                  data as Map<String, dynamic>);
                                              return Expanded(
                                                  child: GlowingWidget(
                                                      child: GlassContainer(
                                                          color: Colors.cyan
                                                              .withAlpha(20),
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 4,
                                                                      bottom:
                                                                          8),
                                                              child: ListTile(
                                                                  subtitle: Padding(
                                                                      padding: EdgeInsets.only(bottom: 4.h),
                                                                      child: insight.output == ""
                                                                          ? const Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.all(8),
                                                                                child: CircularProgressIndicator(
                                                                                  strokeWidth: 2,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              )
                                                                            ])
                                                                          : Column(children: [
                                                                              const Divider(),
                                                                              Text(
                                                                                insight.output,
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                              const Divider(),
                                                                              TextButton.icon(
                                                                                  onPressed: () {
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        builder: (context) {
                                                                                          return Dialog(
                                                                                              child: GlowingWidget(
                                                                                                  style: PaintingStyle.fill,
                                                                                                  opacity: .9,
                                                                                                  child: Container(
                                                                                                      decoration: const BoxDecoration(
                                                                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                                                                      ),
                                                                                                      padding: const EdgeInsets.all(4),
                                                                                                      child: SingleChildScrollView(
                                                                                                        child: Column(children: [
                                                                                                          Container(
                                                                                                              decoration: BoxDecoration(color: Colors.black.withOpacity(1), borderRadius: BorderRadius.circular(8), boxShadow: [
                                                                                                                BoxShadow(color: Colors.white.withOpacity(.1), blurRadius: 8, spreadRadius: 4)
                                                                                                              ]),
                                                                                                              child: Padding(
                                                                                                                padding: const EdgeInsets.all(16),
                                                                                                                child: Column(
                                                                                                                  children: [
                                                                                                                    Text("disclaimer".i18n(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                                                                    const Divider(),
                                                                                                                    Text("disclaimer-text".i18n())
                                                                                                                  ],
                                                                                                                ),
                                                                                                              )),
                                                                                                          Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                                            children: [
                                                                                                              TextButton(
                                                                                                                  style: ButtonStyle(
                                                                                                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                                                                                    backgroundColor: MaterialStateProperty.all(Colors.black.withOpacity(1)),
                                                                                                                    foregroundColor: MaterialStateProperty.all(Colors.white),
                                                                                                                  ),
                                                                                                                  onPressed: () {
                                                                                                                    Navigator.of(context).pop();
                                                                                                                  },
                                                                                                                  child: Text(
                                                                                                                    "ok".i18n(),
                                                                                                                  ))
                                                                                                            ],
                                                                                                          )
                                                                                                        ]),
                                                                                                      ))));
                                                                                        });
                                                                                  },
                                                                                  icon: const Icon(Icons.text_snippet_outlined),
                                                                                  label: Text("disclaimer".i18n()),
                                                                                  style: TextButton.styleFrom(foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), backgroundColor: Colors.white.withOpacity(.1)))
                                                                            ])),
                                                                  title: Row(children: [
                                                                    const Icon(Icons
                                                                        .auto_awesome),
                                                                    SizedBox(
                                                                      width:
                                                                          8.w,
                                                                    ),
                                                                    Text(
                                                                      'astro-intelligence-insight'
                                                                          .i18n(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    )
                                                                  ]))))));
                                            }
                                          }
                                          return GlowingWidget(
                                              child: GlassContainer(
                                                  color:
                                                      Colors.cyan.withAlpha(20),
                                                  child: Center(
                                                      child: ListTile(
                                                    onTap: () {
                                                      Database(uid: "0")
                                                          .createGenerationRequest(
                                                              localizator,
                                                              widget
                                                                  .asteroidData);
                                                    },
                                                    leading: const Icon(
                                                        Icons.auto_awesome),
                                                    title: Text(
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                      "generate-astro-intelligence-insight"
                                                          .i18n(),
                                                    ),
                                                  ))));
                                        },
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            )
                          ],
                        )),
                        const SizedBox(
                          height: 16,
                        ),
                        Divider(
                          height: 8,
                          thickness: 1,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        provider.when(data: (data) {
                          return Column(children: [
                            Text(
                              'neo-approach-dates-text'.i18n(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                                height: 200.w,
                                width: double.infinity,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  clipBehavior: Clip.none,
                                  itemBuilder: (context, index) {
                                    return GlassContainer(
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 4),
                                            child: ApproachDate(
                                              height: 100,
                                              width: 150,
                                              closeApproachData: data
                                                  .closeApproachDataList[index],
                                            )));
                                  },
                                  itemCount: data.closeApproachDataList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          mainAxisExtent: 150),
                                ))
                          ]);
                        }, error: (error, stack) {
                          return Text(error.toString());
                        }, loading: () {
                          return const Center(
                              child: CircularProgressIndicator());
                        }),
                        const SizedBox(
                          height: 16,
                        )
                      ]),
                    ))));
          }))
        ]));
  }
}
