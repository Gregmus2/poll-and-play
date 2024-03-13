import 'package:grpc/grpc.dart';
import 'package:poll_and_play/grpc/authenticator.dart';
import 'package:poll_play_proto_gen/google/protobuf/empty.pb.dart';
import 'package:poll_play_proto_gen/public.dart';

class GamesClient {
  late GamesServiceClient _client;

  GamesClient(List<String> address) {
    final channel = ClientChannel(address[0], port: int.parse(address[1]), options: const ChannelOptions(credentials: ChannelCredentials.insecure()),);
    _client = GamesServiceClient(channel);
  }

  Future<List<GameWithStat>> listGames() async {
    try {
      final response = await _client.listGames(Empty(), options: CallOptions(providers: [Authenticator.authenticate]));
      return response.games;
    } catch (e) {
      // todo handle properly
      print('Error listing games: $e');
      return [];
    }
  }
  
  Future<void> refreshData() async {
    try {
      await _client.refreshData(Empty(), options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error refreshing data: $e');
    }
  }
  
  Future<void> connectSteam(String steamID) async {
    try {
      await _client.connectSteam(ConnectSteamRequest(steamId: steamID), options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error connecting steam: $e');
    }
  }
}