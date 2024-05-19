import 'package:cosmic_beacon/data/firebase/firebase_database.dart';
import 'package:cosmic_beacon/models/shooting_stars.dart';
import 'package:cosmic_beacon/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:localization/localization.dart';
import 'package:share_plus/share_plus.dart';

class UserSettings extends ConsumerStatefulWidget {
  const UserSettings({super.key});

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends ConsumerState<UserSettings> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      body: Stack(
        children: [
          const ShootingStarsBackground(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32.h),
            child: Column(
              children: [
                GlassContainer(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    title: Text("settings".i18n(),
                        style: const TextStyle(fontSize: 18)),
                    leading: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                GlassContainer(
                  color: Colors.green.withOpacity(0.2),
                  child: ListTile(
                    onLongPress: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("export-data-text".i18n()),
                        ),
                      );
                    },
                    onTap: () {
                      user.whenData((value) {
                        Share.share(value.data().toString());
                      });
                    },
                    title: Text('export-data'.i18n(),
                        style: const TextStyle(fontSize: 18)),
                    trailing: const Icon(Icons.download_rounded),
                  ),
                ),
                const SizedBox(height: 64),
                GlassContainer(
                  color: Colors.red.withOpacity(0.2),
                  child: ListTile(
                    onLongPress: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("delete-account-hint".i18n()),
                        ),
                      );
                    },
                    title: Text("delete-account".i18n(),
                        style: const TextStyle(fontSize: 18)),
                    trailing: const Icon(Icons.delete_forever_rounded),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "delete-account".i18n(),
                              textAlign: TextAlign.start,
                            ),
                            content: Text(
                              "delete-account-text".i18n(),
                              textAlign: TextAlign.start,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("no".i18n()),
                              ),
                              TextButton(
                                onPressed: () async {
                                  context.loaderOverlay.show();
                                  FirebaseAuth.instance.currentUser!.delete();
                                  Navigator.of(context).pop();
                                  Future.delayed(
                                    const Duration(milliseconds: 1000),
                                    () {
                                      context.loaderOverlay.hide();
                                      Phoenix.rebirth(context);
                                    },
                                  );
                                },
                                child: Text("yes".i18n()),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
