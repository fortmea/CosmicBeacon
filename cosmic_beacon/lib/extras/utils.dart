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

String? extractTwitterId(String url) {
  final regex = RegExp(r'status/(\d+)');
  final match = regex.firstMatch(url);
  return match?.group(1);
}

String getHtmlString(String tweetId) {
  return """
  <html>
      
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <style>
            *{box-sizing: border-box;margin:0px; padding:0px;}
              #container {
                        display: flex;
                        justify-content: center;
                        margin: 0 auto;
                        max-width:100%;
                        max-height:100%;
                    }      
          </style>
        </head>

        <body>
            <div id="container"></div>
        </body>

        <script id="twitter-wjs" type="text/javascript" async defer src="https://platform.twitter.com/widgets.js" onload="createMyTweet()"></script>
        <script>
      function  createMyTweet() {  

         var twtter = window.twttr;
  
         twttr.widgets.createTweet(
          '$tweetId',
          document.getElementById('container'),
          {
            theme:"dark",
          }
        ).then( function( el ) {
              const widget = document.getElementById('container');
              Twitter.postMessage(widget.clientHeight);
        });
      }
        </script>
        
      </html>
    """;
}
