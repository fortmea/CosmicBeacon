import 'package:cosmic_beacon/fragments/bookmark_fragment.dart';
import 'package:cosmic_beacon/fragments/home_fragment.dart';
import 'package:cosmic_beacon/fragments/image_fragment.dart';
import 'package:cosmic_beacon/fragments/settings_fragment.dart';
import 'package:cosmic_beacon/models/shooting_stars.dart';
import 'package:cosmic_beacon/provider/locale_provider.dart';
import 'package:cosmic_beacon/provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
      const BookmarkFragment(),
      const ImageFragment(),
      SettingsFragment(
        (Locale locale) {
          setState(() {
            context.loaderOverlay.show();
            ref.read(localeProvider.notifier).setLocale(locale);
          });
          Future.delayed(
            const Duration(milliseconds: 1000),
            () {
              setState(() {
                ref.read(localeProvider.notifier).setLocale(locale);
                context.loaderOverlay.hide();
              });
            },
          );
        },
      )
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
        backgroundColor: Colors.white.withOpacity(0.1),
        elevation: 10,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref.read(selectedIndexProvider.notifier).updateDate(index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.search),
            label: 'search'.i18n(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.bookmark),
            label: 'bookmarks'.i18n(),
          ),
          NavigationDestination(
              icon: const Icon(Icons.image), label: 'image'.i18n()),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: 'settings'.i18n(),
          ),
        ],
      ),
    );
  }
}
