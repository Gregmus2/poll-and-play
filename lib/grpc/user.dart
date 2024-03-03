import 'package:grpc/grpc.dart';
import 'package:poll_and_play/grpc/authenticator.dart';
import 'package:poll_play_proto_gen/google.dart';
import 'package:poll_play_proto_gen/public.dart';

class UserClient {
  late UserServiceClient _client;

  UserClient(List<String> address) {
    final channel = ClientChannel(address[0], port: int.parse(address[1]), options: const ChannelOptions(credentials: ChannelCredentials.insecure()),);
    _client = UserServiceClient(channel);
  }

  Future<GetUserResponse> getUser() async {
    GetUserResponse? user;
    try {
      user = await _client.getUser(Empty(), options: CallOptions(providers: [Authenticator.authenticate]));
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
      ), options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error updating user: $e');
    }
  }
}