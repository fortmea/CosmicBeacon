//Run with flutter run | Select-String -NotMatch "updateAcquireFence: Did not find frame." | Select-String -NotMatch "Dropping PlatformView Frame" | Select-String -NotMatch "app_time_stats" | Select-String -NotMatch "Empty SMPTE" | Select-String -NotMatch "Null anb" | Select-String -NotMatch "lockHardwareCanvas" | Select-String -NotMatch "Invalid first_paint"
//debug symbols are found in build\app\intermediates\merged_native_libs
//appbundle can be generated through flutter build appbundle --obfuscate --split-debug-info=build/symbols
//symbols need to be sent to firebase for deobfuscation
//upload symbols with firebase crashlytics:symbols:upload --app <appid> build/symbols
//compress lang files with dart run kompressor -i lib/res/i18n -o lib/res/compressed/i18n
//compress 3d files with dart run kompressor -i lib/res/3d -o lib/res/compressed/3d
//size analysis can be done with flutter build appbundle --target-platform android-arm64 --analyze-size
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmic_beacon/data/api/imgws.dart';
import 'package:cosmic_beacon/extras/theming.dart';
import 'package:cosmic_beacon/models/api_key_singleton.dart';
import 'package:cosmic_beacon/models/custom_page_route.dart';
import 'package:cosmic_beacon/models/url_singleton.dart';
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
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:localization/localization.dart';
import 'data/firebase/firebase_options.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

//import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  ApiKey apiKey = ApiKey();
  UrlSingleton urlSingleton = UrlSingleton();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //MobileAds.instance.initialize();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    print(stack);
    print(error);
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.fetchAndActivate();
  apiKey.apiKey = remoteConfig.getString("api_key");
  urlSingleton.neoAPIUrl = remoteConfig.getString("neoAPIUrl");
  urlSingleton.privacyPolicyUrl = remoteConfig.getString("privacyPolicy");
  urlSingleton.termsOfServiceUrl = remoteConfig.getString("termsOfService");
  urlSingleton.reportBugUrl = remoteConfig.getString("urlReportBug");
  urlSingleton.activateAds = remoteConfig.getBool("activateAds");
  urlSingleton.adMobKey = remoteConfig.getString("adUnitId");
  urlSingleton.testAds = remoteConfig.getBool("testAds");
  urlSingleton.imgAPIUrl = remoteConfig.getString("imgAPIUrl");
  var br = await rootBundle.load('lib/res/compressed/i18n/pt_BR.json.gz');
  var en = await rootBundle.load('lib/res/compressed/i18n/en_US.json.gz');
  FlutterNativeSplash.remove();

  runApp(Phoenix(
      child: ProviderScope(
          child: MyApp(en.buffer.asUint8List(), br.buffer.asUint8List()))));
}

class MyApp extends ConsumerStatefulWidget {
  final Uint8List en;
  final Uint8List pt;
  const MyApp(this.en, this.pt, {super.key});

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
    MapLocalization.delegate.translations = {
      const Locale('en', 'US'):
          json.decode(utf8.decode(gzip.decode(widget.en))),
      const Locale('pt', 'BR'):
          json.decode(utf8.decode(gzip.decode(widget.pt))),
    };
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
                  MapLocalization.delegate,
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
