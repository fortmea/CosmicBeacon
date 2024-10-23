import 'package:cosmic_beacon/data/constants/locales.dart';
import 'package:cosmic_beacon/models/url_singleton.dart';
import 'package:cosmic_beacon/widgets/list_fade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
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
    final Uri url = Uri.parse(UrlSingleton().privacyPolicyUrl);
    if (!await launchUrl(url) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error-open-url'.i18n()),
        ),
      );
    }
  }

  Future<void> openTermsOfService() async {
    final Uri url = Uri.parse(UrlSingleton().termsOfServiceUrl);
    if (!await launchUrl(url) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error-open-url'.i18n()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
          child: listFade(
              child: SingleChildScrollView(
                  child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          GlassContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("home-start-text"
                      .i18n([FirebaseAuth.instance.currentUser!.displayName!])),
                  leading: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                            height: 32,
                            FirebaseAuth.instance.currentUser!.photoURL!),
                      )),
                ),
                Row(children: [
                  Expanded(
                      child: DecoratedBox(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade300.withAlpha(50)),
                    ),
                    child: const SizedBox(
                      height: 1,
                    ),
                  ))
                ]),
                ListTile(
                  trailing: const Icon(Icons.settings_rounded),
                  title: Text("user-settings".i18n()),
                  onTap: () {
                    Navigator.of(context).pushNamed('/user_settings');
                  },
                  onLongPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('user-settings-hint'.i18n()),
                      ),
                    );
                  },
                ),
                Row(children: [
                  Expanded(
                      child: DecoratedBox(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade300.withAlpha(50)),
                    ),
                    child: const SizedBox(
                      height: 1,
                    ),
                  ))
                ]),
                ListTile(
                  trailing: const Icon(Icons.language_rounded),
                  title: Text("set-language".i18n()),
                  onLongPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('set-language-hint'.i18n()),
                      ),
                    );
                  },
                  onTap: () {
                    setState(() {
                      showDropdown = !showDropdown;
                    });
                  },
                ),
                showDropdown
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: supportedLocales.length,
                        itemBuilder: (context, index) {
                          final locale = supportedLocales[index];
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Divider(),
                                ListTile(
                                  title: Text(locale.languageCode.i18n()),
                                  trailing: SvgPicture.asset(
                                    'lib/res/img/${locale.countryCode!.toLowerCase()}.svg',
                                    width: 18,
                                    height: 18,
                                  ),
                                  onTap: () {
                                    widget.setLanguage(locale);
                                  },
                                ),
                              ]);
                        },
                      ).animate(target: showDropdown ? 1.0 : 0.0).fade(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn)
                    : Container(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            child: ListTile(
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('privacy-policy-hint'.i18n()),
                  ),
                );
              },
              onTap: () {
                openPrivacyPolicy();
              },
              title: Text('privacy-policy'.i18n()),
              trailing: const Icon(
                Icons.open_in_new_rounded,
              ),
            ),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            child: ListTile(
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('terms-of-service-hint'.i18n()),
                  ),
                );
              },
              onTap: () {
                openTermsOfService();
              },
              title: Text('terms-of-service'.i18n()),
              trailing: const Icon(
                Icons.open_in_new_rounded,
              ),
            ),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            color: Colors.red.withAlpha(50),
            child: ListTile(
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('logout-hint'.i18n()),
                  ),
                );
              },
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('confirmation'.i18n()),
                      content: Text('logout-confirmation'.i18n()),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('no'.i18n()),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Phoenix.rebirth(context);
                            Navigator.of(context).pop();
                          },
                          child: Text('yes'.i18n()),
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text('settings-logout'.i18n()),
              trailing: const Icon(
                Icons.logout_rounded,
              ),
            ),
          ),
          const SizedBox(height: 32),
          GlassContainer(
            child: ListTile(
              title: Text('report-problem'.i18n()),
              trailing: const Icon(Icons.bug_report_rounded),
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('report-problem-hint'.i18n()),
                  ),
                );
              },
              onTap: () {
                final Uri url = Uri.parse(UrlSingleton().reportBugUrl);
                launchUrl(url).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('error-open-url'.i18n()),
                    ),
                  );
                  return false;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
              if (snapshot.hasData) {
                return GlassContainer(
                  child: ListTile(
                    onLongPress: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${snapshot.data!.appName} v${snapshot.data!.version}+${snapshot.data!.buildNumber} - ${snapshot.data!.installerStore ?? 'Debug'}'),
                        ),
                      );
                    },
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
          const SizedBox(height: 16),
          GlassContainer(
            child: ListTile(
              title: Text('licenses'.i18n()),
              trailing: const Icon(Icons.library_books_outlined),
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('licenses-hint'.i18n()),
                  ),
                );
              },
              onTap: () {
                showLicensePage(
                  context: context,
                );
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 64,
          ),
        ],
      ))))
    ]);
  }
}
