
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:flutter/material.dart';
import 'package:poll_and_play/config.dart';
import 'package:poll_and_play/grpc/friends.dart';
import 'package:poll_play_proto_gen/public.dart';

class FriendsProvider extends ChangeNotifier {
  final FriendsClient _client = FriendsClient(GlobalConfig().friendsAddress.split(':'));
  late List<Friend> _friends;

  Future<void> init() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    await refresh();
  }

  List<Friend> get friends => _friends;

  Future<void> refresh() async {
    _friends = await _client.getFriends();

    notifyListeners();
  }

  Future<void> addFriend($fixnum.Int64 id) async {
    await _client.addFriend(id);
    await refresh();
  }

  Future<void> removeFriend($fixnum.Int64 id) async {
    await _client.removeFriend(id);
    await refresh();
  }
}
