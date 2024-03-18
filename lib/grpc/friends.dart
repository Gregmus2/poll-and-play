import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:poll_and_play/grpc/authenticator.dart';
import 'package:poll_play_proto_gen/google/protobuf/empty.pb.dart';
import 'package:poll_play_proto_gen/public.dart';

class FriendsClient {
  late FriendsServiceClient _client;

  FriendsClient(List<String> address) {
    final channel = GrpcOrGrpcWebClientChannel.toSingleEndpoint(
        host: address[0], port: int.parse(address[1]), transportSecure: false);
    _client = FriendsServiceClient(channel);
  }

  Future<void> addFriend($fixnum.Int64 id) async {
    try {
      await _client.addFriend(AddFriendRequest(friendId: id),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error adding friend: $e');
    }
  }

  Future<List<Friend>> getFriends() async {
    ListFriendsResponse? response;
    try {
      response = await _client.listFriends(Empty(), options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error getting friends: $e');
    }

    return response!.friends;
  }

  Future<void> removeFriend($fixnum.Int64 id) async {
    try {
      await _client.removeFriend(RemoveFriendRequest(friendId: id),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error removing friend: $e');
    }
  }
}
