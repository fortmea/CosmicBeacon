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
