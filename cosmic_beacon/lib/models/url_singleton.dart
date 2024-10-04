class UrlSingleton {
  static final UrlSingleton _instance = UrlSingleton._internal();

  factory UrlSingleton() {
    return _instance;
  }

  UrlSingleton._internal();

  String neoAPIUrl = "";
  String privacyPolicyUrl = "";
  String termsOfServiceUrl = "";
  String reportBugUrl = "";
  String imgAPIUrl = ""; 
  bool testAds = false;
  String? adMobKey;
  bool activateAds = false;
}
