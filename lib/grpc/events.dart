import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:poll_and_play/config.dart';
import 'package:poll_and_play/grpc/authenticator.dart';
import 'package:poll_play_proto_gen/google.dart';
import 'package:poll_play_proto_gen/public.dart';
import 'package:poll_play_proto_gen/public/events.pb.dart';
import 'package:poll_play_proto_gen/public/events.pbgrpc.dart';

class Event {
  $fixnum.Int64? id;
  String? name;
  $fixnum.Int64? startTime;
  EventType? type;
  Int64Value? groupId;
}

class EventsClient {
  late EventsServiceClient _client;

  EventsClient(ClientChannel channel) {
    _client = EventsServiceClient(channel);
  }

  Future<List<ListEventsResponse_EventShort>> listEvents() async {
    try {
      final response = await _client.listEvents(Empty(), options: CallOptions(providers: [Authenticator.authenticate]));
      return response.events;
    } catch (e) {
      // todo handle properly
      print('Error listing groups: $e');
      return [];
    }
  }

  Future<void> createEvent(String? name, DateTime startTime, EventType? type, $fixnum.Int64? groupId,
      List<$fixnum.Int64> userIds, List<$fixnum.Int64> gameIds) async {
    try {
      await _client.createEvent(
          CreateEventRequest(
              name: name,
              startTime: $fixnum.Int64(startTime.millisecondsSinceEpoch),
              type: type,
              groupId: groupId != null ? Int64Value(value: groupId) : null,
              userIds: userIds,
              gameIds: gameIds),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error listing groups: $e');
    }
  }

  Future<void> answerEvent($fixnum.Int64 eventId, bool accept, List<$fixnum.Int64> gameIds, DateTime startTime) async {
    try {
      await _client.answerEvent(
          AnswerEventRequest(
              eventId: eventId,
              accept: accept,
              gameIds: gameIds,
              startTime: $fixnum.Int64(startTime.millisecondsSinceEpoch)),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error listing groups: $e');
    }
  }

  Future<Event> getEvent($fixnum.Int64 eventId) async {
    try {
      final response = await _client.getEvent(
          GetEventRequest(eventId: eventId),
          options: CallOptions(providers: [Authenticator.authenticate]));
      return Event()
        ..id = response.id
        ..name = response.name
        ..startTime = response.startTime
        ..type = response.type
        ..groupId = response.groupId;
    } catch (e) {
      // todo handle properly
      print('Error listing groups: $e');
      return Event();
    }
  }

  Future<List<GetEventGamesResponse_Game>> getEventGames($fixnum.Int64 eventId) async {
    try {
      final response = await _client.getEventGames(
          GetEventRequest(eventId: eventId),
          options: CallOptions(providers: [Authenticator.authenticate]));

      return response.games;
    } catch (e) {
      // todo handle properly
      print('Error listing groups: $e');

      return [];
    }
  }

  Future<List<GetEventMembersResponse_EventMember>> getEventMembers($fixnum.Int64 eventId) async {
    try {
      final response = await _client.getEventMembers(
          GetEventRequest(eventId: eventId),
          options: CallOptions(providers: [Authenticator.authenticate]));

      return response.members;
    } catch (e) {
      // todo handle properly
      print('Error listing groups: $e');

      return [];
    }
  }

  Future<void> inviteUser($fixnum.Int64 eventId, $fixnum.Int64 userId) async {
    try {
      await _client.inviteUser(
          InviteUserRequest(eventId: eventId, userId: userId),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error listing groups: $e');
    }
  }

  Future<void> removeUser($fixnum.Int64 eventId, $fixnum.Int64 userId) async {
    try {
      await _client.removeUser(
          InviteUserRequest(eventId: eventId, userId: userId),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error listing groups: $e');
    }
  }

  Future<void> updateEvent($fixnum.Int64 eventId, String? name, DateTime startTime) async {
    try {
      await _client.updateEvent(
          UpdateEventRequest(
              id: eventId,
              name: name,
              startTime: $fixnum.Int64(startTime.millisecondsSinceEpoch)),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error listing groups: $e');
    }
  }
}
