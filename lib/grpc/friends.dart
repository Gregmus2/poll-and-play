import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:grpc/grpc.dart';
import 'package:poll_play_proto_gen/google/protobuf/empty.pb.dart';
import 'package:poll_play_proto_gen/public/friends.pbgrpc.dart';

class FriendsClient {
  late FriendsServiceClient _client;

  FriendsClient(String host) {
    final channel = ClientChannel(host, options: const ChannelOptions(credentials: ChannelCredentials.insecure()),);
    _client = FriendsServiceClient(channel);
  }

  Future<void> addFriend($fixnum.Int64 id) async {
    try {
      await _client.addFriend(AddFriendRequest(friendId: id));
    } catch (e) {
      // todo handle properly
      print('Error adding friend: $e');
    }
  }

  Future<List<Friend>> getFriends() async {
    ListFriendsResponse? response;
    try {
      response = await _client.listFriends(Empty());
    } catch (e) {
      // todo handle properly
      print('Error getting friends: $e');
    }

    return response!.friends;
  }
}