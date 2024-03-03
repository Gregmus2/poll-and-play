import 'package:grpc/grpc.dart';
import 'package:poll_and_play/grpc/authenticator.dart';
import 'package:poll_play_proto_gen/public.dart';

class RegistrationClient {
  late RegistrationServiceClient _client;

  RegistrationClient(List<String> address) {
    final channel = ClientChannel(address[0], port: int.parse(address[1]), options: const ChannelOptions(credentials: ChannelCredentials.insecure()),);
    _client = RegistrationServiceClient(channel);
  }

  Future<void> register(String name, email, firebaseID) async {
    try {
      await _client.register(RegisterRequest(
        name: name,
        email: email,
        firebaseId: firebaseID
      ), options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error on registration: $e');
    }
  }
}