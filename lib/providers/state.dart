import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// todo make all properties for all classes private (which are not used outside) and add getters/setters if necessary

class StateProvider extends ChangeNotifier {
  // todo replace with user object and add steam id
  User? _user;

  StateProvider();

  Future<void> init() async {
    _initUser();
  }

  void _initUser() {
    if (FirebaseAuth.instance.currentUser != null) {
      _user = FirebaseAuth.instance.currentUser;
    }
  }

  User? get user => _user;

  set user(User? user) {
    _user = user;
    notifyListeners();
  }
}
