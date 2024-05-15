import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsFragment extends ConsumerWidget {
  const SettingsFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> openPrivacyPolicy() async {
      final Uri _url =
          Uri.parse('https://fortmea.tech/cosmicbeacon/privacy_policy.html');
      if (!await launchUrl(_url)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error-open-url'.i18n()),
          ),
        );
      }
    }

    Future<void> openTermsOfService() async {
      final Uri _url =
          Uri.parse('https://fortmea.tech/cosmicbeacon/terms_conditions.html');
      if (!await launchUrl(_url)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error-open-url'.i18n()),
          ),
        );
      }
    }

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            GlassContainer(
              child: ListTile(
                title: Text("home-start-text"
                    .i18n([FirebaseAuth.instance.currentUser!.displayName!])),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                      height: 32, FirebaseAuth.instance.currentUser!.photoURL!),
                ),
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
                      Icons.open_in_new,
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            GestureDetector(
                onTap: () {
                  openTermsOfService();
                },
                child: GlassContainer(
                  child: ListTile(
                    title: Text('terms-of-service'.i18n()),
                    trailing: const Icon(
                      Icons.open_in_new,
                    ),
                  ),
                )),
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
                      Icons.logout,
                    ),
                  ),
                )),
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
                }),
          ],
        ));
  }
}
