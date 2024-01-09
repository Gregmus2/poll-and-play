import 'package:flutter/material.dart';
import 'package:poll_and_play/common/theme_data.dart';
import 'package:poll_and_play/pages/home.dart';
import 'package:poll_and_play/pages/login.dart';
import 'package:poll_and_play/providers/state.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    StateProvider stateProvider = Provider.of<StateProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Poll And Play',
      home: stateProvider.user != null ? const HomePage() : const LoginPage(),
      theme: getThemeData(context),
    );
  }
}