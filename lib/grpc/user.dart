import 'package:grpc/grpc.dart';
import 'package:poll_and_play/grpc/authenticator.dart';
import 'package:poll_play_proto_gen/google.dart';
import 'package:poll_play_proto_gen/public.dart';

class UserClient {
  late UserServiceClient _client;

  UserClient(ClientChannel channel) {
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

  Future<void> updateUser(String? name) async {
    try {
      await _client.updateUser(UpdateUserRequest(name: StringValue(value: name)),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error updating user: $e');
    }
  }

  Future<void> registerDevice(String? token, Platform platform) async {
    try {
      await _client.registerDevice(RegisterDeviceRequest(token: token, platform: platform),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error registering device: $e');
    }
  }
}
