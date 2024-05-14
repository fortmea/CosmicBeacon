import 'package:cosmic_beacon/models/equatable_list.dart';
import 'package:cosmic_beacon/provider/neo_provider.dart';
import 'package:cosmic_beacon/provider/user_provider.dart';
import 'package:cosmic_beacon/widgets/neo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';

class BookmarkFragment extends ConsumerWidget {
  final void Function(String) onTap;
  const BookmarkFragment(this.onTap, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSnapshot = ref.watch(userProvider);

    return Column(
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
                      child: ListView.builder(
                    itemBuilder: (context, index) {
                      final asteroidData = neoList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Neo(
                          asteroidData: asteroidData,
                          onTap: () {
                            Navigator.of(context).pushNamed('/neo_full',
                                arguments: {
                                  'asteroidData': asteroidData,
                                  'bookmarked': true
                                });
                          },
                          isModelViewerVisible: lista.length < 5,
                        ),
                      );
                    },
                    itemCount: neoList.length,
                  ));
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              );
            } else {
              // Handle case where lista is empty
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
    );
  }
}
