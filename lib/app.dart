import 'package:flutter/material.dart';
import 'package:poll_and_play/common/theme_data.dart';
import 'package:poll_and_play/pages/login.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Poll And Play',
      home: const LoginPage(),
      theme: getThemeData(context),
      themeMode: ThemeMode.dark,
    );
  }
}
