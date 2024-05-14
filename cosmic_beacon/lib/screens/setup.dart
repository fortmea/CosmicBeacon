import 'package:cosmic_beacon/models/asteroid_data.dart';
import 'package:cosmic_beacon/models/custom_page_route.dart';
import 'package:cosmic_beacon/models/shooting_stars.dart';
import 'package:cosmic_beacon/provider/neo_provider.dart';
import 'package:cosmic_beacon/screens/login.dart';
import 'package:cosmic_beacon/screens/neo_full.dart';
import 'package:cosmic_beacon/widgets/glass_button.dart';
import 'package:cosmic_beacon/widgets/glass_date_picker.dart';
import 'package:cosmic_beacon/widgets/neo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cosmic_beacon/provider/date_provider.dart';
import 'package:localization/localization.dart';

class Setup extends ConsumerWidget {
  const Setup({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final provider = ref.watch(neoDataProvider(selectedDate));

    return Scaffold(
        //appBar: AppBar(title: const Text('Select your date of birth')),
        body: Stack(children: [
      const ShootingStarsBackground(),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                'setup-start-text'.i18n(),
                style: const TextStyle(fontSize: 24),
              )
                  .animate(target: (selectedDate != null) ? 0 : 1)
                  .fade(duration: const Duration(milliseconds: 500)),
              const SizedBox(height: 32),
              Row(children: [
                Expanded(
                    child: GlassDateTimePicker(
                  borderRadius: 10,
                  onDateTimeSelected: (DateTime? dateTime) {
                    ref
                        .read(selectedDateProvider.notifier)
                        .updateDate(dateTime ?? DateTime.now());
                  },
                )),
              ]),
              const SizedBox(height: 16),
              (selectedDate != null)
                  ? provider.when(data: (data) {
                      //print(data);
                      final nData = filterByDateApproximateDateAndTime(
                          selectedDate, data);
                      return Expanded(
                          child: Column(children: [
                        Expanded(
                          child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Neo(
                                    asteroidData: nData[index],
                                    isModelViewerVisible: false,
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(CustomPageRoute(NeoFull(
                                        asteroidData: nData[index],
                                        bookmarked: false,
                                      )));
                                    },
                                  ),
                                );
                              },
                              itemCount: nData.length),
                        ),
                        Text("setup-end-text".i18n(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                ))
                            .animate()
                            .fade(duration: const Duration(milliseconds: 500)),
                      ]));
                    }, loading: () {
                      return Column(children: [
                        const SizedBox(height: 32),
                        const CircularProgressIndicator().animate().fade(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 500)),
                      ]);
                    }, error: (error, stack) {
                      print(error.toString());
                      print(stack.toString());
                      return Text(error.toString());
                    })
                  : const SizedBox(),
              const SizedBox(height: 16),
              selectedDate == null
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                            height: 50,
                            width: 100,
                            child: GlassButton(
                                child: Text("next".i18n(),
                                    style: const TextStyle(fontSize: 18)),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/login');
                                }))
                      ],
                    ).animate().fade(
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 500)),
            ],
          ))),
    ]));
  }
}
