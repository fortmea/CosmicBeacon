import 'package:cosmic_beacon/fragments/bookmark_fragment.dart';
import 'package:cosmic_beacon/fragments/home_fragment.dart';
import 'package:cosmic_beacon/models/shooting_stars.dart';
import 'package:cosmic_beacon/provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _Home();
}

@override
class _Home extends ConsumerState<Home> {
  var neoToOpen = '';
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final fragments = [
      const HomeFragment(),
      BookmarkFragment((str) {
        setState(() {
          neoToOpen = str;
        });
        print(neoToOpen);
      }),
    ];
    return Scaffold(
      body: Stack(children: [
        const ShootingStarsBackground(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Center(
            child: fragments[selectedIndex],
          ),
        ),
      ]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 10,
        selectedIndex: selectedIndex!,
        onDestinationSelected: (index) {
          ref.read(selectedIndexProvider.notifier).updateDate(index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            label: 'home'.i18n(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.bookmark),
            label: 'bookmarks'.i18n(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: 'settings'.i18n(),
          ),
        ],
      ),
    );
  }
}
