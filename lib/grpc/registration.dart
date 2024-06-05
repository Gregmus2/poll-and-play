import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:poll_and_play/grpc/authenticator.dart';
import 'package:poll_play_proto_gen/public.dart';

class RegistrationClient {
  late RegistrationServiceClient _client;

  RegistrationClient(GrpcOrGrpcWebClientChannel channel) {
    _client = RegistrationServiceClient(channel);
  }

  Future<void> register(String name, email, firebaseID, photo) async {
    try {
      await _client.register(RegisterRequest(name: name, email: email, firebaseId: firebaseID, picture: photo),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error on registration: $e');
    }
  }
}
