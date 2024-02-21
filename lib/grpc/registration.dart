import 'package:grpc/grpc.dart';
import 'package:poll_play_proto_gen/public.dart';
import 'package:poll_play_proto_gen/public/registration.pb.dart';

class RegistrationClient {
  late RegistrationServiceClient _client;

  RegistrationClient(String host) {
    final channel = ClientChannel(host, options: const ChannelOptions(credentials: ChannelCredentials.insecure()),);
    _client = RegistrationServiceClient(channel);
  }

  Future<void> register(String name, email, firebaseID) async {
    try {
      await _client.register(RegisterRequest(
        name: name,
        email: email,
        firebaseId: firebaseID
      ));
    } catch (e) {
      // todo handle properly
      print('Error on registration: $e');
    }
  }
}