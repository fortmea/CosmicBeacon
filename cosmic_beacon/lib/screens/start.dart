import 'package:cosmic_beacon/models/asteroid_data.dart';
import 'package:cosmic_beacon/models/custom_page_route.dart';
import 'package:cosmic_beacon/models/shooting_stars.dart';
import 'package:cosmic_beacon/screens/setup.dart';
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

  Map<String, dynamic> asteroidJson = {
    "id": "2398188",
    "neo_reference_id": "2398188",
    "name": "398188 Agni (2010 LE15)",
    "name_limited": "Agni",
    "designation": "398188",
    "nasa_jpl_url":
        "https://ssd.jpl.nasa.gov/tools/sbdb_lookup.html#/?sstr=2398188",
    "absolute_magnitude_h": 19.33,
    "estimated_diameter": {
      "kilometers": {
        "estimated_diameter_min": 0.3618719966,
        "estimated_diameter_max": 0.8091703835
      },
      "meters": {
        "estimated_diameter_min": 361.8719965994,
        "estimated_diameter_max": 809.1703835499
      },
      "miles": {
        "estimated_diameter_min": 0.2248567644,
        "estimated_diameter_max": 0.5027950104
      },
      "feet": {
        "estimated_diameter_min": 1187.2441213233,
        "estimated_diameter_max": 2654.758561166
      }
    },
    "is_potentially_hazardous_asteroid": true,
    "close_approach_data": [
      {
        "close_approach_date": "1902-05-31",
        "close_approach_date_full": "1902-May-31 20:19",
        "epoch_date_close_approach": -2132883660000,
        "relative_velocity": {
          "kilometers_per_second": "9.0566323755",
          "kilometers_per_hour": "32603.8765516467",
          "miles_per_hour": "20258.7809606607"
        },
        "miss_distance": {
          "astronomical": "0.241190643",
          "lunar": "93.823160127",
          "kilometers": "36081606.45673041",
          "miles": "22420070.619723258"
        },
        "orbiting_body": "Earth"
      },
      {
        "close_approach_date": "1902-11-23",
        "close_approach_date_full": "1902-Nov-23 19:22",
        "epoch_date_close_approach": -2117680680000,
        "relative_velocity": {
          "kilometers_per_second": "10.643663992",
          "kilometers_per_hour": "38317.1903713721",
          "miles_per_hour": "23808.8119838117"
        },
        "miss_distance": {
          "astronomical": "0.3676517669",
          "lunar": "143.0165373241",
          "kilometers": "54999921.229976503",
          "miles": "34175366.3195136214"
        },
        "orbiting_body": "Earth"
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser ?? "No user logged in");
    AsteroidData asteroidData = AsteroidData.fromJson(asteroidJson);

    return Scaffold(
        body: Stack(children: [
      const ShootingStarsBackground(),
      Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(children: [
                const SizedBox(height: 32),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                      Image.asset(
                        'lib/res/img/bg.jpg',
                        width: 200.w,
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
                                child: Row(children: [
                              Expanded(
                                  child: Neo(
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/setup');
                      },
                      child: GlassContainer(
                          width: 100.w,
                          height: 30.h,
                          borderRadius: BorderRadius.circular(16),
                          blur: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Center(
                                child: Text(
                                  "home-button".i18n(),
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
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: Text("skip".i18n(),
                      style: const TextStyle(
                        fontSize: 14,
                      )),
                )
              ])))
    ]));
  }
}
