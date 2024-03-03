import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/api/steam.dart';
import 'package:http/http.dart' as http;
import 'package:poll_and_play/config.dart';
import 'package:poll_and_play/providers/state.dart';

class GamesProvider extends ChangeNotifier {
  final SteamAPI _steamAPI = SteamAPI(GlobalConfig().steamAPIKey);
  late StateProvider _stateProvider;
  late List<SteamGame> _games;

  GamesProvider(StateProvider stateProvider) {
    _stateProvider = stateProvider;
  }

  Future<void> init() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    await refresh();
  }

  List<SteamGame> get games => _games;

  Future<void> refresh() async {
    // todo replace with steam id from state provider
    // todo add also friends that has this game
    _games = await _steamAPI.getGames("");

    notifyListeners();
  }
}
