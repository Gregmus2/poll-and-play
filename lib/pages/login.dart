import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/providers/state.dart';
import 'package:poll_and_play/utils/sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Center(
          child: IconButton(
              onPressed: () {
                _signIn(context);
              },
              icon: const Icon(Icons.login)),
        ));
  }
}

Future<void> _signIn(BuildContext context) async {
  StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);

  UserCredential user = await signInWithGoogle();
  // todo init repo and other stuff

  // after user updates in state provider, it notify app page about that to rebuild body with HomePage
  stateProvider.user = user.user;
}
