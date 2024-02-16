import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/page.dart' as page;

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
    return Placeholder();
  }
}
