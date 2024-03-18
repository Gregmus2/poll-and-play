import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:poll_and_play/config.dart';
import 'package:poll_and_play/grpc/registration.dart';
import 'package:poll_and_play/providers/friends.dart';
import 'package:poll_and_play/providers/games.dart';
import 'package:poll_and_play/providers/groups.dart';
import 'package:poll_and_play/providers/state.dart';
import 'package:poll_and_play/utils/sign_in.dart';
import 'package:provider/provider.dart';

import 'home.dart';

const List<String> scopes = <String>['email', 'profile'];

GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: GlobalConfig().clientID,
  scopes: scopes,
);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount? _googleUser;
  bool _isAuthorized = false;
  bool readyToUpdate = false;

  @override
  void initState() {
    super.initState();

    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;
      // However, on web...
      if (kIsWeb && account != null) {
        isAuthorized = await googleSignIn.canAccessScopes(scopes);
      }

      setState(() {
        _googleUser = account;
        _isAuthorized = isAuthorized;
      });

      if (_isAuthorized) {
        readyToUpdate = true;
      }
    });

    if (!_isAuthorized && _googleUser == null) {
      googleSignIn.signInSilently();
    }
  }

  @override
  Widget build(BuildContext context) {
    StateProvider stateProvider = Provider.of<StateProvider>(context);
    if (stateProvider.user != null) {
      return const HomePage();
    }
    if (readyToUpdate) {
      _updateUser(context);
      readyToUpdate = false;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Center(
          child: _googleUser == null
              ? IconButton(onPressed: _handleSignIn, icon: const Icon(Icons.login))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GoogleUserCircleAvatar(
                      identity: _googleUser!,
                    ),
                    if (!_isAuthorized) ...<Widget>[
                      const Text('Additional permissions needed to read your profile'),
                      ElevatedButton(
                        onPressed: _handleAuthorizeScopes,
                        child: const Text('REQUEST PERMISSIONS'),
                      ),
                    ],
                    ElevatedButton(
                      onPressed: _handleSignOut,
                      child: const Text('SIGN OUT'),
                    ),
                  ],
                ),
        ));
  }

  Future<void> _handleAuthorizeScopes() async {
    final bool isAuthorized = await googleSignIn.requestScopes(scopes);
    setState(() {
      _isAuthorized = isAuthorized;
    });
    if (isAuthorized) {
      setState(() {
        readyToUpdate = true;
      });
    }
  }

  Future<void> _handleSignOut() => googleSignIn.disconnect();

  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _updateUser(BuildContext context) async {
    StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);
    RegistrationClient registrationClient = Provider.of<RegistrationClient>(context, listen: false);
    FriendsProvider friendsProvider = Provider.of<FriendsProvider>(context, listen: false);
    GamesProvider gamesProvider = Provider.of<GamesProvider>(context, listen: false);
    GroupsProvider groupsProvider = Provider.of<GroupsProvider>(context, listen: false);

    final GoogleSignInAuthentication googleAuth = await _googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final user = await FirebaseAuth.instance.signInWithCredential(credential);
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
    stateProvider.initUser();
  }
}
