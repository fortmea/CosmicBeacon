import 'package:universal_io/io.dart';

import 'package:cosmic_beacon/extras/utils.dart';
import 'package:cosmic_beacon/models/asteroid_data.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';

class ApproachDate extends StatelessWidget {
  final CloseApproachData closeApproachData;
  final double height;
  final double width;
  const ApproachDate(
      {super.key,
      required this.closeApproachData,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child: GlassContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(children: [
                  Text(
                    textAlign: TextAlign.start,
                    DateFormat.yMd(Platform.localeName).add_Hm().format(
                        parseCustomDate(
                            closeApproachData.closeApproachDateFull)),
                  )
                ]),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "neo-orbiting-body"
                          .i18n([closeApproachData.orbitingBody.i18n()]),
                      textAlign: TextAlign.start,
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
