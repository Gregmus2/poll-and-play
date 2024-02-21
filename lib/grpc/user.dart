import 'package:grpc/grpc.dart';
import 'package:poll_play_proto_gen/google.dart';
import 'package:poll_play_proto_gen/public.dart';

class UserClient {
  late UserServiceClient _client;

  UserClient(String host) {
    final channel = ClientChannel(host, options: const ChannelOptions(credentials: ChannelCredentials.insecure()),);
    _client = UserServiceClient(channel);
  }

  Future<GetUserResponse> getUser() async {
    GetUserResponse? user;
    try {
      user = await _client.getUser(Empty());
    } catch (e) {
      // todo handle properly
      print('Error getting user: $e');
    }

    return user!;
  }

  Future<void> updateUser(String name, steamID) async {
    try {
      await _client.updateUser(UpdateUserRequest(
        name: name,
        steamId: steamID
      ));
    } catch (e) {
      // todo handle properly
      print('Error updating user: $e');
    }
  }
}