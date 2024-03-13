import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/config.dart';
import 'package:poll_and_play/grpc/games.dart';
import 'package:poll_play_proto_gen/public.dart';

class GamesProvider extends ChangeNotifier {
  final GamesClient _client = GamesClient(GlobalConfig().gamesAddress.split(':'));
  late List<GameWithStat> _games;

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
}