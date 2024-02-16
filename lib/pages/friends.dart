import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/page.dart' as page;

class FriendsPage extends StatelessWidget implements page.Page {
  const FriendsPage({super.key});

  @override
  Icon getIcon(BuildContext context) {
    return const Icon(Icons.people, color: Colors.white);
  }
  
  @override
  Icon getUnselectedIcon(BuildContext context) {
    return const Icon(Icons.people_alt_outlined, color: Colors.white);
  }

  @override
  String getLabel() {
    return "Friends";
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
