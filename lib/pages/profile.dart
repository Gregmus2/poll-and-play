import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/page.dart' as page;
import 'package:poll_and_play/providers/state.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget implements page.Page {
  const ProfilePage({super.key});

  @override
  Icon getIcon(BuildContext context) {
    return const Icon(Icons.person, color: Colors.white);
  }

  @override
  Icon getUnselectedIcon(BuildContext context) {
    return const Icon(Icons.person_outline, color: Colors.white);
  }

  @override
  String getLabel() {
    return "Profile";
  }

  @override
  Widget build(BuildContext context) {
    StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);

    return MaterialButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          stateProvider.user = null;
        },
        child: const Text('Sign Out'));
  }
}
