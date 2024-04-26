import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/grpc/games.dart';
import 'package:poll_and_play/providers/provider.dart';
import 'package:poll_play_proto_gen/public.dart';

class GamesProvider extends ChangeNotifier implements Provider {
  final GamesClient _client;
  late List<GameWithStat> _games;

  GamesProvider(this._client);

  @override
  Future<void> init() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    await refresh();
  }

  List<GameWithStat> get games => _games;

  Future<void> refresh() async {
    await _client.refreshData();
    _games = await _client.listGames();

    notifyListeners();
  }

  Future<void> connectSteam(String steamID) async {
    await _client.connectSteam(steamID);
    _games = await _client.listGames();

    notifyListeners();
  }
  
  List<GameWithStat> search(String query) {
    return _games.where((element) => element.game.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
