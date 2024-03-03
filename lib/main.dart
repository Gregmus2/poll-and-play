import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/app.dart';
import 'package:poll_and_play/config.dart';
import 'package:poll_and_play/firebase_options.dart';
import 'package:poll_and_play/grpc/friends.dart';
import 'package:poll_and_play/grpc/registration.dart';
import 'package:poll_and_play/grpc/user.dart';
import 'package:poll_and_play/providers/friends.dart';
import 'package:poll_and_play/providers/games.dart';
import 'package:poll_and_play/providers/groups.dart';
import 'package:poll_and_play/providers/state.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  _runApp(const App());
}

Future<void> _runApp(Widget app) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  StateProvider stateProvider = StateProvider();
  await stateProvider.init();
  UserClient userClient = UserClient(GlobalConfig().userAddress.split(':'));
  FriendsProvider friendsProvider = FriendsProvider();
  GroupsProvider groupsProvider = GroupsProvider();
  RegistrationClient registrationClient = RegistrationClient(GlobalConfig().registrationAddress.split(':'));
  GamesProvider gamesProvider = GamesProvider(stateProvider);

  await Future.wait([
    friendsProvider.init(),
    groupsProvider.init(),
    gamesProvider.init(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => stateProvider),
        Provider(create: (context) => userClient),
        ChangeNotifierProvider(create: (context) => friendsProvider),
        Provider(create: (context) => registrationClient),
        ChangeNotifierProvider(create: (context) => gamesProvider),
        ChangeNotifierProvider(create: (context) => groupsProvider),
      ],
      child: app,
    ),
  );
}
