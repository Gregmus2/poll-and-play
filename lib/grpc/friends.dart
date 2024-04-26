import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:poll_and_play/config.dart';
import 'package:poll_and_play/grpc/authenticator.dart';
import 'package:poll_play_proto_gen/google/protobuf/empty.pb.dart';
import 'package:poll_play_proto_gen/public.dart';

class FriendsClient {
  late FriendsServiceClient _client;

  FriendsClient(ClientChannel channel) {
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

  Future<List<User>> getFriends() async {
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

  Future<List<SearchResponse_SearchResult>> search(String username) async {
    SearchResponse? response;
    try {
      response = await _client.search(SearchRequest(username: username),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error searching friends: $e');
    }

    return response!.friends;
  }
}
