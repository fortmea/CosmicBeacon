import 'package:cosmic_beacon/models/asteroid_data.dart';
import 'package:cosmic_beacon/models/custom_page_route.dart';
import 'package:cosmic_beacon/provider/date_provider.dart';
import 'package:cosmic_beacon/provider/locale_provider.dart';
import 'package:cosmic_beacon/provider/neo_provider.dart';
import 'package:cosmic_beacon/provider/user_provider.dart';
import 'package:cosmic_beacon/screens/neo_full.dart';
import 'package:cosmic_beacon/widgets/glass_date_picker.dart';
import 'package:cosmic_beacon/widgets/list_fade.dart';
import 'package:cosmic_beacon/widgets/neo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';

class HomeFragment extends ConsumerWidget {
  const HomeFragment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final provider = ref.watch(neoDataProvider(selectedDate));
    final locale = ref.watch(localeProvider);
    var lista = [];
    user.when(
      data: (data) {
        if (data.data() != null) {
          final dados = data.data()! as Map<String, dynamic>;
          lista = dados["bookmarked"] as List<dynamic>;
        }
      },
      error: (error, stackTrace) {},
      loading: () {},
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(
          height: 32,
        ),
        Text(
                "welcome-home-text".i18n([
                  FirebaseAuth.instance.currentUser!.displayName!.split(" ")[0]
                ]),
                style: const TextStyle(fontSize: 24))
            .animate()
            .fadeIn(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 500)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
              child: GlassDateTimePicker(
            onAction: () {
              ref.read(selectedDateProvider.notifier).updateDate(null);
            },
            actionIcon: Icons.clear_rounded,
            clearOnAction: true,
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
                final nData =
                    filterByDateApproximateDateAndTime(selectedDate, data);
                return Expanded(
                    child: Column(children: [
                  Expanded(
                    child: listFade(
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.only(bottom: 8, top: 8),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Neo(
                                      locale: locale,
                                      asteroidData: nData[index],
                                      isModelViewerVisible: false,
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(CustomPageRoute(NeoFull(
                                          asteroidData: nData[index],
                                          bookmarked:
                                              lista.contains(nData[index].id),
                                        )));
                                      },
                                    ),
                                  );
                                },
                                itemCount: nData.length))
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 250)),
                  ),
                ]));
              }, loading: () {
                return Column(children: [
                  const SizedBox(height: 32),
                  const CircularProgressIndicator().animate().fade(
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 500)),
                ]);
              }, error: (error, stack) {
                return Text(error.toString());
              })
            : const SizedBox(),
      ],
    );
  }
}
