import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:poll_and_play/adapters/cloud_messaging.dart';
import 'package:poll_and_play/app.dart';
import 'package:poll_and_play/config.dart';
import 'package:poll_and_play/firebase_options.dart';
import 'package:poll_and_play/grpc/events.dart';
import 'package:poll_and_play/grpc/friends.dart';
import 'package:poll_and_play/grpc/games.dart';
import 'package:poll_and_play/grpc/groups.dart';
import 'package:poll_and_play/grpc/registration.dart';
import 'package:poll_and_play/grpc/user.dart';
import 'package:poll_and_play/providers/events.dart';
import 'package:poll_and_play/providers/friends.dart';
import 'package:poll_and_play/providers/games.dart';
import 'package:poll_and_play/providers/groups.dart';
import 'package:poll_and_play/providers/state.dart';
import 'package:provider/provider.dart';

// todo add firebase analytics library
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  _runApp(const App());
}

Future<void> _runApp(Widget app) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final address = GlobalConfig().apiAddress.split(':');
  final channel = GrpcOrGrpcWebClientChannel.toSingleEndpoint(
      host: address[0], port: int.parse(address[1]), transportSecure: GlobalConfig().secureTransport);

  UserClient userClient = UserClient(channel);
  EventsClient eventsClient = EventsClient(channel);
  RegistrationClient registrationClient = RegistrationClient(channel);
  FriendsClient friendsClient = FriendsClient(channel);
  GroupsClient groupsClient = GroupsClient(channel);
  GamesClient gamesClient = GamesClient(channel);

  FriendsProvider friendsProvider = FriendsProvider(friendsClient);
  GroupsProvider groupsProvider = GroupsProvider(groupsClient);
  GamesProvider gamesProvider = GamesProvider(gamesClient);
  EventsProvider eventsProvider = EventsProvider(eventsClient);
  CloudMessaging messaging = CloudMessaging(userClient);
  init() async {
    await Future.wait([
      friendsProvider.init(),
      groupsProvider.init(),
      gamesProvider.init(),
      messaging.init(),
      eventsProvider.init(),
    ]);
  }

  StateProvider stateProvider = StateProvider(init, userClient);
  await stateProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => stateProvider),
        Provider(create: (context) => userClient),
        ChangeNotifierProvider(create: (context) => friendsProvider),
        Provider(create: (context) => registrationClient),
        ChangeNotifierProvider(create: (context) => gamesProvider),
        ChangeNotifierProvider(create: (context) => groupsProvider),
        ChangeNotifierProvider(create: (context) => eventsProvider),
        Provider(create: (context) => eventsClient),
      ],
      child: app,
    ),
  );
}
