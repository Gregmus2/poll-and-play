import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/app.dart';
import 'package:poll_and_play/firebase_options.dart';
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => stateProvider),
      ],
      child: app,
    ),
  );
}
