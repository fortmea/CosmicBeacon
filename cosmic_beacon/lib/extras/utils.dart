

import 'package:flutter/foundation.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

DateTime parseCustomDate(String dateString) {
  DateFormat inputFormat = DateFormat('yyyy-MMM-dd HH:mm');
  DateTime parsedDate = inputFormat.parse(dateString);

  return parsedDate;
}

/*
 InterstitialAd? interstitialAd;
final adUnitId = Platform.isAndroid
    ? 'ca-app-pub-3940256099942544/1033173712'
    : 'ca-app-pub-3940256099942544/4411468910';

/// Loads an interstitial ad.
void loadAd() {
  InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          interstitialAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ));
}
*/