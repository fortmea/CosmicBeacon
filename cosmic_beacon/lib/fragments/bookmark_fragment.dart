import 'package:cosmic_beacon/data/firebase/firebase_database.dart';
import 'package:cosmic_beacon/models/equatable_list.dart';
import 'package:cosmic_beacon/provider/neo_provider.dart';
import 'package:cosmic_beacon/provider/user_provider.dart';
import 'package:cosmic_beacon/widgets/glass_button.dart';
import 'package:cosmic_beacon/widgets/neo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:localization/localization.dart';

class BookmarkFragment extends ConsumerWidget {
  const BookmarkFragment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSnapshot = ref.watch(userProvider);

    return Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            userSnapshot.when(
              data: (userData) {
                final dados = userData.data()! as Map<String, dynamic>;
                final lista = dados["bookmarked"] as List<dynamic>;

                if (lista.isNotEmpty) {
                  final neoData = ref.watch(multipleNeoDetailedDataProvider(
                    EquatableList(lista),
                  ));

                  return neoData.when(
                    data: (neoList) {
                      return Expanded(
                          child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                                child: GlassContainer(
                              child: ListTile(
                                onTap: () {
                                  //Create a dialog to confirm the action
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('clear-favorites'.i18n()),
                                          content: Text(
                                              'clear-favorites-text'.i18n()),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Database(uid: userData.id)
                                                    .updateUserData([]);
                                              },
                                              child: Text('yes'.i18n()),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('no'.i18n()),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                title: Text('clear-favorites'.i18n()),
                                trailing: const Icon(
                                  Icons.delete_rounded,
                                ),
                              ),
                            ))
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                            child: ListView.builder(
                          itemBuilder: (context, index) {
                            final asteroidData = neoList[index];
                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Dismissible(
                                  direction: DismissDirection.endToStart,
                                  confirmDismiss: (direction) {
                                    Database(uid: userData.id)
                                        .addBookmark(asteroidData.id);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      action: SnackBarAction(
                                        label: 'undo'.i18n(),
                                        onPressed: () {
                                          Database(uid: userData.id)
                                              .addBookmark(asteroidData.id);
                                        },
                                      ),
                                      content: Text('bookmark-removed'.i18n()),
                                    ));
                                    return Future.value(true);
                                  },
                                  key: Key(asteroidData.id),
                                  background: const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.delete_rounded,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                  child: Neo(
                                    preferedMeasurementUnit: null,
                                    asteroidData: asteroidData,
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/neo_full', arguments: {
                                        'asteroidData': asteroidData,
                                        'bookmarked': true
                                      });
                                    },
                                    isModelViewerVisible: false,
                                  ),
                                ));
                          },
                          itemCount: neoList.length,
                        ))
                      ]));
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => Text('Error: $error'),
                  );
                } else {
                  return Text(
                    "bookmark-no-data-text".i18n(),
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  );
                }
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ));
  }
}
