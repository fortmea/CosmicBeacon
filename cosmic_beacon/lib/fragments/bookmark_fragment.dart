import 'package:cosmic_beacon/data/firebase/firebase_database.dart';
import 'package:cosmic_beacon/models/equatable_list.dart';
import 'package:cosmic_beacon/provider/neo_provider.dart';
import 'package:cosmic_beacon/provider/user_provider.dart';
import 'package:cosmic_beacon/widgets/neo.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:localization/localization.dart';
import 'package:cosmic_beacon/widgets/list_fade.dart';

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
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('clear-favorites'.i18n()),
                                          content: Text(
                                              'clear-favorites-text'.i18n()),
                                          actions: [
                                            OutlinedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('no'.i18n()),
                                            ),
                                            OutlinedButton(
                                              onPressed: () {
                                                final partial = neoList;
                                                Navigator.of(context).pop();
                                                Database(uid: userData.id)
                                                    .updateUserData([]);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'bookmarks-cleared'
                                                          .i18n()),
                                                  action: SnackBarAction(
                                                      label: "undo".i18n(),
                                                      onPressed: () {
                                                        Database(
                                                                uid:
                                                                    userData.id)
                                                            .updateUserData(
                                                                partial
                                                                    .map((e) =>
                                                                        e.id)
                                                                    .toList());
                                                      }),
                                                ));
                                              },
                                              child: Text('yes'.i18n()),
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
                            child: ListFade(
                                child: ListView.builder(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).padding.bottom + 16,
                              top: MediaQuery.of(context).padding.top + 16),
                          physics: const BouncingScrollPhysics(),
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
                        ))),
                      ]));
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) {
                      FirebaseCrashlytics.instance.recordError(
                        error,
                        stack,
                      );
                      return Text('Error: $error');
                    },
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
