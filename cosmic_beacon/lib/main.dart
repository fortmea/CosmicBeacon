//Run with flutter run | Select-String -NotMatch "updateAcquireFence: Did not find frame." | Select-String -NotMatch "Dropping PlatformView Frame" | Select-String -NotMatch "app_time_stats" | Select-String -NotMatch "Empty SMPTE" | Select-String -NotMatch "Null anb" | Select-String -NotMatch "lockHardwareCanvas" | Select-String -NotMatch "Invalid first_paint"

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmic_beacon/extras/theming.dart';
import 'package:cosmic_beacon/models/api_key_singleton.dart';
import 'package:cosmic_beacon/models/custom_page_route.dart';
import 'package:cosmic_beacon/provider/locale_provider.dart';
import 'package:cosmic_beacon/screens/home.dart';
import 'package:cosmic_beacon/screens/login.dart';
import 'package:cosmic_beacon/screens/neo_full.dart';
import 'package:cosmic_beacon/screens/setup.dart';
import 'package:cosmic_beacon/screens/start.dart';
import 'package:cosmic_beacon/screens/user_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:localization/localization.dart';
import 'data/firebase/firebase_options.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
//teste

void main() async {
  ApiKey apiKey = ApiKey();
  WidgetsFlutterBinding.ensureInitialized();
  print("Agora vai");
  MobileAds.instance.initialize();

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
  runApp(Phoenix(child: const ProviderScope(child: MyApp())));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription<DocumentSnapshot>? userSubscription;
  Timer? periodicTimer;

  @override
  void initState() {
    super.initState();
    startPeriodicCheck();
  }

  void listenToUserDataChanges() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return;
    }

    userSubscription?.cancel();

    try {
      userSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots()
          .listen((DocumentSnapshot snapshot) {
        final data = snapshot.exists;

        if (!data) {
          context.loaderOverlay.show();
          FirebaseAuth.instance.signOut().then((value) {
            Phoenix.rebirth(context);
            context.loaderOverlay.hide();
          });
          // Close app
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void startPeriodicCheck() {
    periodicTimer?.cancel(); // Ensure no multiple timers
    periodicTimer = Timer.periodic(const Duration(seconds: 5), (t) {
      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;

        if (userId == null) {
          userSubscription?.cancel();
        } else {
          listenToUserDataChanges();
        }
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  void dispose() {
    periodicTimer?.cancel();
    userSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
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
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: TextScaler.noScaling),
                    child: child!,
                  );
                },
                locale: locale,
                onGenerateRoute: (settings) {
                  if (settings.name == '/neo_full') {
                    final args = settings.arguments as Map<String, dynamic>;
                    return CustomPageRoute(NeoFull(
                      asteroidData: args['asteroidData'],
                      bookmarked: args['bookmarked'],
                    ));
                  } else if (settings.name == '/setup') {
                    if (FirebaseAuth.instance.currentUser != null) {
                      return CustomPageRoute(const Home());
                    } else {
                      return CustomPageRoute(const Setup());
                    }
                  } else if (settings.name == '/login') {
                    if (FirebaseAuth.instance.currentUser != null) {
                      return CustomPageRoute(const Home());
                    } else {
                      return CustomPageRoute(const Login());
                    }
                  } else if (settings.name == '/') {
                    if (FirebaseAuth.instance.currentUser != null) {
                      return CustomPageRoute(const Home());
                    } else {
                      return CustomPageRoute(const Start());
                    }
                  } else if (settings.name == '/home') {
                    if (FirebaseAuth.instance.currentUser != null) {
                      return CustomPageRoute(const Home());
                    } else {
                      return CustomPageRoute(const Login());
                    }
                  } else if (settings.name == "/user_settings") {
                    if (FirebaseAuth.instance.currentUser != null) {
                      return CustomPageRoute(const UserSettings());
                    } else {
                      return CustomPageRoute(const Login());
                    }
                  } else {
                    if (FirebaseAuth.instance.currentUser != null) {
                      return CustomPageRoute(const Home());
                    } else {
                      return CustomPageRoute(const Start());
                    }
                  }
                },
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
                initialRoute:
                    FirebaseAuth.instance.currentUser != null ? '/home' : '/',
              ));
        });
  }
}
