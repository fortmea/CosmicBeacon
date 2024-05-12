//Run with flutter run | Select-String -NotMatch "updateAcquireFence: Did not find frame." | Select-String -NotMatch "Dropping PlatformView Frame" | Select-String -NotMatch "app_time_stats" | Select-String -NotMatch "Empty SMPTE" | Select-String -NotMatch "Null anb" | Select-String -NotMatch "lockHardwareCanvas" | Select-String -NotMatch "Invalid first_paint"

import 'package:cosmic_beacon/extras/theming.dart';
import 'package:cosmic_beacon/models/api_key_singleton.dart';
import 'package:cosmic_beacon/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'data/firebase/firebase_options.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

void main() async {
  ApiKey apiKey = ApiKey();
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('res/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.fetchAndActivate();
  apiKey.apiKey = remoteConfig.getString("api_key");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/res/i18n'];
    return ScreenUtilInit(
        designSize: const Size(440, 440),
        minTextAdapt: true,
        builder: (_, child) {
          return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: MaterialApp(
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  LocalJsonLocalization.delegate,
                ],
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('pt', 'BR'),
                ],
                debugShowCheckedModeBanner: false,
                title: 'Cosmic Beacon',
                theme: meuTema,
                home: const Home(),
              ));
        });
  }
}
