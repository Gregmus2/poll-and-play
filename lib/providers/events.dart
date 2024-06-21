import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:flutter/material.dart';
import 'package:poll_and_play/grpc/events.dart';
import 'package:poll_and_play/providers/provider.dart';
import 'package:poll_play_proto_gen/public.dart' as proto;

class EventsProvider extends ChangeNotifier implements Provider {
  final EventsClient _client;
  late List<proto.ListEventsResponse_EventShort> _events;
  bool _updateSeen = true;

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

  set updateSeen (bool value) {
    _updateSeen = value;

    notifyListeners();
  }

  set updateSeenSilent (bool value) {
    _updateSeen = value;
  }

  bool get updateSeen => _updateSeen;

  Future<void> createEvent(String name, DateTime startTime, proto.EventType type, $fixnum.Int64? groupId,
      List<$fixnum.Int64> userIds, List<$fixnum.Int64> gameIds) async {
    await _client.createEvent(name, startTime, type, groupId, userIds, gameIds);
    await refresh();
  }

  Future<void> answerEvent($fixnum.Int64 eventId, bool accept, List<$fixnum.Int64> gameIds, DateTime? startTime) async {
    await _client.answerEvent(eventId, accept, gameIds, startTime);
    await refresh();
  }

  Future<void> deleteEvent($fixnum.Int64 eventId) async {
    await _client.deleteEvent(eventId);
    await refresh();
  }
}
