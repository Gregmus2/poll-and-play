import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/page.dart' as page;

class GamesPage extends StatelessWidget implements page.Page {
  const GamesPage({super.key});

  @override
  Icon getIcon(BuildContext context) {
    return const Icon(Icons.gamepad, color: Colors.white);
  }

  @override
  Icon getUnselectedIcon(BuildContext context) {
    return const Icon(Icons.gamepad_outlined, color: Colors.white);
  }

  @override
  String getLabel() {
    return "Games";
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
