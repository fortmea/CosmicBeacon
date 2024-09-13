import 'package:cosmic_beacon/provider/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cosmic_beacon/extras/utils.dart';
import 'package:cosmic_beacon/models/asteroid_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';

class ApproachDate extends ConsumerWidget {
  final CloseApproachData closeApproachData;
  final double height;
  final double width;
  const ApproachDate(
      {super.key,
      required this.closeApproachData,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locale = ref.watch(localeProvider);
    return Center(
        child: Container(
      constraints: BoxConstraints(
        maxHeight: height,
        maxWidth: width,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textAlign: TextAlign.start,
            DateFormat.yMd(locale.countryCode).add_Hm().format(
                parseCustomDate(closeApproachData.closeApproachDateFull)),
          ),
          const SizedBox(height: 8),
          Text(
            "neo-orbiting-body".i18n([closeApproachData.orbitingBody.i18n()]),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    ));
  }
}
