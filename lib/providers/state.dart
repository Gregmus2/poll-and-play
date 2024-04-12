import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:poll_and_play/config.dart';
import 'package:poll_and_play/grpc/user.dart';
import 'package:poll_and_play/providers/provider.dart';
import 'package:poll_play_proto_gen/public.dart' as proto;

// todo make all properties for all classes private (which are not used outside) and add getters/setters if necessary

class StateProvider extends ChangeNotifier implements Provider {
  final UserClient _client = UserClient(GlobalConfig().apiAddress.split(':'));
  proto.User? _user;
  late PackageInfo packageInfo;
  Future<void> Function() initFunction;

  StateProvider(this.initFunction);

  @override
  Future<void> init() async {
    await initUser();
    packageInfo = await PackageInfo.fromPlatform();
  }

  Future<void> initUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      _user = (await _client.getUser()).user;
      await initFunction();
    }

    notifyListeners();
  }

  void updateUser(String? name) async {
    await _client.updateUser(name);
    _user = (await _client.getUser()).user;

    notifyListeners();
  }

  void resetUser() {
    _user = null;
    notifyListeners();
  }

  proto.User? get user => _user;
}
