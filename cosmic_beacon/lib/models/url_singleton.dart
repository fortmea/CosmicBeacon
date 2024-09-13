class UrlSingleton {
  static final UrlSingleton _instance = UrlSingleton._internal();

  factory UrlSingleton() {
    return _instance;
  }

  UrlSingleton._internal();

  String _neoAPIUrl = "";
  String _privacyPolicyUrl = "";
  String _termsOfServiceUrl = "";
  String _reportBugUrl = "";

  String get neoAPIUrl => _neoAPIUrl;
  String get privacyPolicyUrl => _privacyPolicyUrl;
  String get termsOfServiceUrl => _termsOfServiceUrl;
  String get reportBugUrl => _reportBugUrl;
  bool _testAds = false;
  String? _adMobKey;
  bool _activateAds = false;
  bool get testAds => _testAds;
  String? get adMobKey => _adMobKey;
  bool get activateAds => _activateAds;

  set testAds(bool value) {
    _testAds = value;
  }

  set adMobKey(String? value) {
    _adMobKey = value;
  }

  set activateAds(bool value) {
    _activateAds = value;
  }

  set neoAPIUrl(String value) {
    _neoAPIUrl = value;
  }

  set privacyPolicyUrl(String value) {
    _privacyPolicyUrl = value;
  }

  set termsOfServiceUrl(String value) {
    _termsOfServiceUrl = value;
  }

  set reportBugUrl(String value) {
    _reportBugUrl = value;
  }
}
