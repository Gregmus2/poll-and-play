import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/page.dart' as page;

class GroupsPage extends StatelessWidget implements page.Page {
  const GroupsPage({super.key});

  @override
  Icon getIcon(BuildContext context) {
    return const Icon(Icons.group_add_rounded, color: Colors.white);
  }

  @override
  Icon getUnselectedIcon(BuildContext context) {
    return const Icon(Icons.group_add_outlined, color: Colors.white);
  }

  @override
  String getLabel() {
    return "Groups";
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
