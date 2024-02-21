import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/app.dart';
import 'package:poll_and_play/config.dart';
import 'package:poll_and_play/firebase_options.dart';
import 'package:poll_and_play/grpc/friends.dart';
import 'package:poll_and_play/grpc/registration.dart';
import 'package:poll_and_play/grpc/user.dart';
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
  UserClient userClient = UserClient(GlobalConfig().userAddress);
  FriendsClient friendsClient = FriendsClient(GlobalConfig().friendsAddress);
  RegistrationClient registrationClient = RegistrationClient(GlobalConfig().registrationAddress);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => stateProvider),
        Provider(create: (context) => userClient),
        Provider(create: (context) => friendsClient),
        Provider(create: (context) => registrationClient),
      ],
      child: app,
    ),
  );
}
