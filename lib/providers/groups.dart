import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:flutter/material.dart';
import 'package:poll_and_play/config.dart';
import 'package:poll_and_play/grpc/groups.dart';
import 'package:poll_play_proto_gen/public.dart';

class GroupsProvider extends ChangeNotifier {
  final GroupsClient _client = GroupsClient(GlobalConfig().groupsAddress.split(':'));
  late List<Group> _groups;

  Future<void> init() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    await refresh();
  }

  List<Group> get groups => _groups;

  Group? getGroup($fixnum.Int64 id) {
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
}
