import 'dart:io';

import 'package:cosmic_beacon/models/asteroid_data.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:localization/localization.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:intl/intl.dart';

class Neo extends StatefulWidget {
  final AsteroidData asteroidData;
  final bool isModelViewerVisible;
  final void Function() onTap;
  const Neo(
      {Key? key,
      required this.asteroidData,
      required this.isModelViewerVisible,
      required this.onTap})
      : super(key: key);

  @override
  _NeoState createState() => _NeoState();
}

class _NeoState extends State<Neo> {
  DateTime parseCustomDate(String dateString) {
    DateFormat inputFormat = DateFormat('yyyy-MMM-dd HH:mm');
    DateTime parsedDate = inputFormat.parse(dateString);

    return parsedDate;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        
        onTap: widget.onTap,
        child: GlassContainer(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 128,
                        child: widget.isModelViewerVisible
                            ? ModelViewer(
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
                              )
                            : Container(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.asteroidData.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
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
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
