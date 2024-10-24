import 'package:cosmic_beacon/widgets/cycling_text.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';

import 'package:cosmic_beacon/models/asteroid_data.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:localization/localization.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Neo extends StatefulWidget {
  final AsteroidData asteroidData;
  final bool isModelViewerVisible;
  final void Function() onTap;
  final MeasurementUnits? preferedMeasurementUnit;
  final Locale locale;
  const Neo(
      {super.key,
      required this.asteroidData,
      required this.isModelViewerVisible,
      required this.onTap,
      this.preferedMeasurementUnit,
      required this.locale});

  @override
  _NeoState createState() => _NeoState();
}

class _NeoState extends State<Neo> {
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

  DateTime parseCustomDate(String dateString) {
    DateFormat inputFormat = DateFormat('yyyy-MMM-dd HH:mm');
    DateTime parsedDate = inputFormat.parse(dateString);

    return parsedDate;
  }

  @override
  void initState() {
    load3d();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final distanceList = widget
        .asteroidData.closeApproachDataList[0].missDistance
        .toJson()
        .entries
        .toList();

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
                        child: widget.isModelViewerVisible && file3d != null
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
                                interactionPrompt: InteractionPrompt.none,
                              )
                            : const SizedBox(),
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
                              DateFormat.yMd(widget.locale.languageCode)
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
                          Row(
                            children: [
                              Text(
                                'distance'.i18n(),
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              widget.preferedMeasurementUnit == null
                                  ? FadingTextCycleWidget(
                                      duration: const Duration(seconds: 3),
                                      texts: distanceList.map((e) {
                                        return e.key.i18n([
                                          NumberFormat.decimalPattern(
                                                  widget.locale.languageCode)
                                              .format(double.parse(e.value))
                                        ]);
                                      }).toList())
                                  : Text(widget.preferedMeasurementUnit
                                      .toString()
                                      .split('.')
                                      .last
                                      .i18n([
                                      NumberFormat.decimalPattern(
                                              widget.locale.languageCode)
                                          .format(double.parse(distanceList
                                              .where((element) =>
                                                  element.key ==
                                                  widget.preferedMeasurementUnit
                                                      .toString()
                                                      .split('.')
                                                      .last)
                                              .first
                                              .value))
                                    ])),
                            ],
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
