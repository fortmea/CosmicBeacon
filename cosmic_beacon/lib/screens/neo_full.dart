import 'dart:io';

import 'package:cosmic_beacon/data/firebase/firebase_database.dart';
import 'package:cosmic_beacon/extras/utils.dart';
import 'package:cosmic_beacon/models/asteroid_data.dart';
import 'package:cosmic_beacon/models/shooting_stars.dart';
import 'package:cosmic_beacon/provider/bookmarked_provider.dart';
import 'package:cosmic_beacon/provider/neo_provider.dart';
import 'package:cosmic_beacon/provider/user_provider.dart';
import 'package:cosmic_beacon/widgets/approach_date.dart';
import 'package:cosmic_beacon/widgets/cycling_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:intl/intl.dart';

class NeoFull extends ConsumerStatefulWidget {
  final AsteroidData asteroidData;
  var bookmarked;
  NeoFull({
    super.key,
    required this.asteroidData,
    this.bookmarked = false,
  });

  @override
  ConsumerState<NeoFull> createState() => _NeoFull();
}

@override
class _NeoFull extends ConsumerState<NeoFull> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () async {
      ref.read(bookmarkedProvider.notifier).updateBookmarked(widget.bookmarked);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(neoDetailedDataProvider(widget.asteroidData.id));
    final bookmark = ref.watch(bookmarkedProvider);

    final distanceList = widget
        .asteroidData.closeApproachDataList[0].missDistance
        .toJson()
        .entries
        .toList();

    return Scaffold(
        appBar: AppBar(
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
                            .updateBookmarked(!widget.bookmarked);
                      },
                    )
                  : const SizedBox()
            ],
            title: Text(
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                widget.asteroidData.name.split("(")[1].split(")")[0])),
        body: Stack(children: [
          const ShootingStarsBackground(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: Column(children: [
              Column(
                children: [
                  SizedBox(
                      height: 128,
                      child: ModelViewer(
                        backgroundColor: Colors.transparent,
                        src: 'lib/res/3d/a3.glb',
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
                        interactionPrompt: InteractionPrompt.none,
                      )),
                  Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            'neo-hazardous'.i18n([],
                                [widget.asteroidData.isPotentiallyHazardous]),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'neo-orbiting-body'.i18n([
                              widget.asteroidData.closeApproachDataList[0]
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
                                  duration: const Duration(seconds: 3),
                                  texts: distanceList.map((e) {
                                    return e.key.i18n([
                                      NumberFormat.decimalPattern(
                                              Platform.localeName)
                                          .format(double.parse(e.value))
                                    ]);
                                  }).toList())
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(children: [
                Expanded(
                    child: DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10)),
                  child: const SizedBox(
                    height: 1,
                  ),
                ))
              ]),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: provider.when(data: (data) {
                  return Column(children: [
                    Text(
                      'neo-approach-dates-text'.i18n(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                        child: GridView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 4.0),
                          child: ApproachDate(
                            height: 64,
                            width: 64,
                            closeApproachData:
                                data.closeApproachDataList[index],
                          ),
                        );
                      },
                      itemCount: data.closeApproachDataList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                    ))
                  ]);
                }, error: (error, stack) {
                  print(error.toString());
                  print(stack.toString());
                  return Text(error.toString());
                }, loading: () {
                  return const Center(child: CircularProgressIndicator());
                }),
              ),
            ]),
          )
        ]));
  }
}