import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:flutter/material.dart';
import 'package:poll_and_play/config.dart';
import 'package:poll_and_play/grpc/groups.dart';
import 'package:poll_and_play/providers/provider.dart';
import 'package:poll_play_proto_gen/public.dart' as proto;

class GroupsProvider extends ChangeNotifier implements Provider {
  final GroupsClient _client;
  late List<proto.Group> _groups;

  GroupsProvider(this._client);

  @override
  Future<void> init() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    await refresh();
  }

  List<proto.Group> get groups => _groups;

  proto.Group? getGroup($fixnum.Int64 id) {
    return _groups.where((element) => element.id == id).firstOrNull;
  }

  Future<void> createGroup(String name) async {
    await _client.createGroup(name);
    refresh();
  }

  Future<void> refresh() async {
    _groups = await _client.listGroups();

    notifyListeners();
  }

  Future<void> updateGroup($fixnum.Int64 id, String name) async {
    _client.updateGroup(id, name);
    _groups.firstWhere((element) => element.id == id).name = name;

    notifyListeners();
  }

  Future<void> deleteGroup($fixnum.Int64 id) async {
    _client.deleteGroup(id);
    _groups.removeWhere((element) => element.id == id);

    notifyListeners();
  }

  Future<void> inviteToGroup($fixnum.Int64 groupId, $fixnum.Int64 userId) async {
    await _client.inviteToGroup(groupId, userId);
    final i = _groups.indexWhere((element) => element.id == groupId);
    _groups[i] = await _client.getGroup(groupId);

    notifyListeners();
  }

  Future<void> removeUserFromGroup($fixnum.Int64 groupId, $fixnum.Int64 userId) async {
    await _client.removeUserFromGroup(groupId, userId);
    final i = _groups.indexWhere((element) => element.id == groupId);
    _groups[i] = await _client.getGroup(groupId);

    notifyListeners();
  }

  Future<List<proto.User>> searchMembers($fixnum.Int64 groupId, String username) async {
    return _client.searchMembers(groupId, username);
  }
}
