import 'dart:io';

import 'package:cosmic_beacon/data/mock/asteroid.dart';
import 'package:cosmic_beacon/models/asteroid_data.dart';
import 'package:cosmic_beacon/models/shooting_stars.dart';
import 'package:cosmic_beacon/widgets/neo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:localization/localization.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

 
  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser ?? "No user logged in");
    AsteroidData asteroidData = AsteroidData.fromJson(mockAsteroidJson);

    return Scaffold(
        body: Stack(children: [
      const ShootingStarsBackground(),
      Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 32,
              ),
              child: Column(children: [
                const SizedBox(height: 32),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                      Image.asset(
                        'lib/res/img/bg.jpg',
                        width: 200.h,
                        height: MediaQuery.of(context).size.width < 600
                            ? 200.w
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "welcome-text".i18n(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "home-description".i18n(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width >
                                                    500
                                                ? 200.w
                                                : MediaQuery.of(context)
                                                    .size
                                                    .width
                                                    .w,
                                      ),
                                      child: Neo(
                                        locale: Locale(Platform.localeName),
                                        asteroidData: asteroidData,
                                        onTap: () {},
                                        isModelViewerVisible: true,
                                      ))
                                ]))
                          ],
                        ),
                      ),
                    ]).animate().fade(
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 500))),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: GlassContainer(
                          width: 200.w,
                          height: 30.h,
                          borderRadius: BorderRadius.circular(16),
                          blur: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                  child: Text("skip".i18n(),
                                      softWrap: true,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ))))),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/setup');
                      },
                      child: GlassContainer(
                          color: Colors.green.withAlpha(50),
                          width: 150.w,
                          height: 30.h,
                          borderRadius: BorderRadius.circular(16),
                          blur: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Center(
                                child: Text.rich(
                                  TextSpan(
                                      text: "home-button".i18n(),
                                      children: const [
                                        WidgetSpan(
                                            child: Icon(
                                          Icons.arrow_forward,
                                          size: 16,
                                          color: Colors.white,
                                        ))
                                      ]),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ))),
                    ),
                  ],
                ),
                /*const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: Text("skip".i18n(),
                      style: const TextStyle(
                        fontSize: 20,
                      )),
                ),*/
              ])))
    ]));
  }
}
