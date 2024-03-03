import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/grpc/registration.dart';
import 'package:poll_and_play/providers/friends.dart';
import 'package:poll_and_play/providers/games.dart';
import 'package:poll_and_play/providers/groups.dart';
import 'package:poll_and_play/providers/state.dart';
import 'package:poll_and_play/utils/sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login', style: Theme.of(context).textTheme.titleLarge),
        ),
        body: Center(
          child: IconButton(
              onPressed: () {
                _signIn(context);
              },
              icon: Icon(Icons.login, color: Theme.of(context).iconTheme.color)),
        ));
  }
}

Future<void> _signIn(BuildContext context) async {
  StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);
  RegistrationClient registrationClient = Provider.of<RegistrationClient>(context, listen: false);
  FriendsProvider friendsProvider = Provider.of<FriendsProvider>(context, listen: false);
  GamesProvider gamesProvider = Provider.of<GamesProvider>(context, listen: false);
  GroupsProvider groupsProvider = Provider.of<GroupsProvider>(context, listen: false);

  UserCredential user = await signInWithGoogle();

  if (user.user != null && user.additionalUserInfo!.isNewUser) {
    final userData = user.user!;
    registrationClient.register(userData.displayName ?? "", userData.email, userData.uid);
  }

  await Future.wait([
    friendsProvider.init(),
    groupsProvider.init(),
    gamesProvider.init(),
  ]);

  // after user updates in state provider, it notify app page about that to rebuild body with HomePage
  stateProvider.user = user.user;
}
