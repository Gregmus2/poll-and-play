import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:flutter/material.dart';
import 'package:poll_and_play/grpc/events.dart';
import 'package:poll_and_play/providers/provider.dart';
import 'package:poll_play_proto_gen/public.dart' as proto;

class EventsProvider extends ChangeNotifier implements Provider {
  final EventsClient _client;
  late List<proto.ListEventsResponse_EventShort> _events;

  EventsProvider(this._client);

  @override
  Future<void> init() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    await refresh();
  }

  List<proto.ListEventsResponse_EventShort> get events => _events;

  proto.ListEventsResponse_EventShort? getGroup($fixnum.Int64 id) {
    return _events.where((element) => element.id == id).firstOrNull;
  }

  Future<void> refresh() async {
    _events = await _client.listEvents();

    notifyListeners();
  }
}
