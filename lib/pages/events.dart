import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/page.dart' as page;

class EventsPage extends StatelessWidget implements page.Page {
  const EventsPage({super.key});

  @override
  Icon getIcon(BuildContext context) {
    return const Icon(Icons.event, color: Colors.white);
  }

  @override
  Icon getUnselectedIcon(BuildContext context) {
    return const Icon(Icons.event_outlined, color: Colors.white);
  }

  @override
  String getLabel() {
    return "Events";
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
