class GlobalConfig {
  static final GlobalConfig _singleton = GlobalConfig._internal();

  late String clientID;
  late String apiAddress;
  late String steamAPIKey;
  late bool secureTransport;

  GlobalConfig._internal() {
    const String clientID = String.fromEnvironment('CLIENT_ID');
    if (clientID.isEmpty) {
      throw AssertionError('CLIENT_ID is not set');
    }
    this.clientID = clientID;

    const String apiAddress = String.fromEnvironment('API_ADDRESS');
    if (apiAddress.isEmpty) {
      throw AssertionError('API_ADDRESS is not set');
    }
    this.apiAddress = apiAddress;

    const String steamAPIKey = String.fromEnvironment('STEAM_API_KEY');
    if (steamAPIKey.isEmpty) {
      throw AssertionError('STEAM_API_KEY is not set');
    }
    this.steamAPIKey = steamAPIKey;

    secureTransport = const bool.fromEnvironment('SECURE_TRANSPORT');
  }

  factory GlobalConfig() {
    return _singleton;
  }
}
