//import 'package:flutter/foundation.dart';
import 'package:cosmic_beacon/data/constants/strings.dart';
import 'package:cosmic_beacon/models/url_singleton.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

InterstitialAd? interstitialAd;
int adsShown = 0;

DateTime parseCustomDate(String dateString) {
  DateFormat inputFormat = DateFormat('yyyy-MMM-dd HH:mm');
  DateTime parsedDate = inputFormat.parse(dateString);

  return parsedDate;
}

/// Loads an interstitial ad.
void loadAd() {
  if (UrlSingleton().activateAds && adsShown % 2 == 1) {
    InterstitialAd.load(
        adUnitId: UrlSingleton().testAds
            ? interstitialAdUnit
            : UrlSingleton().adMobKey!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }
}

showAd() {
  if (UrlSingleton().activateAds && interstitialAd != null) {
    interstitialAd?.show();
  } else {
    return;
  }
  adsShown++;
}
