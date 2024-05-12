class ApiKey {
  static final ApiKey _instance = ApiKey._internal();

  factory ApiKey() {
    return _instance;
  }

  ApiKey._internal();

  String _apiKey = "";

  String get apiKey => _apiKey;

  set apiKey(String value) {
    _apiKey = value;
  }
}
