class GlobalConfig {
  static final GlobalConfig _singleton = GlobalConfig._internal();

  late String clientID;
  late String userAddress;
  late String friendsAddress;
  late String registrationAddress;

  GlobalConfig._internal() {
    const String clientID = String.fromEnvironment('CLIENT_ID');
    if (clientID.isEmpty) {
      throw AssertionError('CLIENT_ID is not set');
    }
    this.clientID = clientID;

    const String userAddress = String.fromEnvironment('USER_ADDRESS');
    if (userAddress.isEmpty) {
      throw AssertionError('USER_ADDRESS is not set');
    }
    this.userAddress = userAddress;

    const String friendsAddress = String.fromEnvironment('FRIENDS_ADDRESS');
    if (friendsAddress.isEmpty) {
      throw AssertionError('FRIENDS_ADDRESS is not set');
    }
    this.friendsAddress = friendsAddress;

    const String registrationAddress = String.fromEnvironment('REGISTRATION_ADDRESS');
    if (registrationAddress.isEmpty) {
      throw AssertionError('REGISTRATION_ADDRESS is not set');
    }
    this.registrationAddress = registrationAddress;
  }

  factory GlobalConfig() {
    return _singleton;
  }
}