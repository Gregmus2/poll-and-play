import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:flutter/material.dart';
import 'package:poll_and_play/config.dart';
import 'package:poll_and_play/grpc/friends.dart';
import 'package:poll_and_play/providers/provider.dart';
import 'package:poll_play_proto_gen/public.dart' as proto;

class FriendsProvider extends ChangeNotifier implements Provider {
  final FriendsClient _client = FriendsClient(GlobalConfig().apiAddress.split(':'));
  late List<proto.User> _friends;

  @override
  Future<void> init() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    await refresh();
  }

  List<proto.User> get friends => _friends;

  Future<void> refresh() async {
    _friends = await _client.getFriends();

    notifyListeners();
  }

  Future<void> addFriend($fixnum.Int64 id) async {
    await _client.addFriend(id);
    await refresh();

    notifyListeners();
  }

  Future<void> removeFriend($fixnum.Int64 id) async {
    await _client.removeFriend(id);
    await refresh();

    notifyListeners();
  }

  Future<List<proto.SearchResponse_SearchResult>> search(String username) async {
    return _client.search(username);
  }
}
