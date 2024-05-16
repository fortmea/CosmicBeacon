import 'package:cosmic_beacon/data/constants/strings.dart';
import 'package:cosmic_beacon/main.dart';
import 'package:cosmic_beacon/provider/locale_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsFragment extends ConsumerStatefulWidget {
  final void Function(Locale locale) setLanguage;
  const SettingsFragment(this.setLanguage, {super.key});

  @override
  _SettingsFragmentState createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends ConsumerState<SettingsFragment> {
  bool showDropdown = false;

  Future<void> openPrivacyPolicy() async {
    final Uri _url = Uri.parse(privacyPolicy);
    if (!await launchUrl(_url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error-open-url'.i18n()),
        ),
      );
    }
  }

  Future<void> openTermsOfService() async {
    final Uri _url = Uri.parse(termsOfService);
    if (!await launchUrl(_url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error-open-url'.i18n()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          GlassContainer(
            child: Column(
              children: [
                ListTile(
                  title: Text("home-start-text"
                      .i18n([FirebaseAuth.instance.currentUser!.displayName!])),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                        height: 32,
                        FirebaseAuth.instance.currentUser!.photoURL!),
                  ),
                ),
                ListTile(
                  trailing: const Icon(Icons.language_rounded),
                  title: Text("set-language".i18n()),
                  onTap: () {
                    setState(() {
                      showDropdown = !showDropdown;
                    });
                  },
                ),
                showDropdown
                    ? Column(
                        children: [
                          ListTile(
                            title: Text("portuguese".i18n()),
                            trailing: const Flag.fromString('BR',
                                height: 24, width: 24),
                            onTap: () {
                              widget.setLanguage(const Locale("pt"));
                            },
                          ),
                          ListTile(
                            title: Text("english".i18n()),
                            trailing: const Flag.fromString(
                              'US',
                              height: 24,
                              width: 24,
                            ),
                            onTap: () {
                              widget.setLanguage(const Locale("en"));
                            },
                          ),
                        ],
                      ).animate(target: showDropdown ? 1.0 : 0.0).fade(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn)
                    : Container(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              openPrivacyPolicy();
            },
            child: GlassContainer(
              child: ListTile(
                title: Text('privacy-policy'.i18n()),
                trailing: const Icon(
                  Icons.open_in_new_rounded,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              openTermsOfService();
            },
            child: GlassContainer(
              child: ListTile(
                title: Text('terms-of-service'.i18n()),
                trailing: const Icon(
                  Icons.open_in_new_rounded,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('confirmation'.i18n()),
                    content: Text('logout-confirmation'.i18n()),
                    actions: [
                      TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Phoenix.rebirth(context);
                          Navigator.of(context).pop();
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
                },
              );
            },
            child: GlassContainer(
              child: ListTile(
                title: Text('settings-logout'.i18n()),
                trailing: const Icon(
                  Icons.logout_rounded,
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
              if (snapshot.hasData) {
                return GlassContainer(
                  child: ListTile(
                    title: Text('app-version'.i18n([
                      '${snapshot.data!.version}+${snapshot.data!.buildNumber}'
                    ])),
                    trailing: const Icon(Icons.info_outline_rounded),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
