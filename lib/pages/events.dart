import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/event_create.dart';
import 'package:poll_and_play/pages/page.dart' as page;

class EventsPage extends StatelessWidget implements page.Page {
  const EventsPage({super.key});

  @override
  Icon getIcon(BuildContext context) {
    return const Icon(Icons.event);
  }

  @override
  Icon getUnselectedIcon(BuildContext context) {
    return const Icon(Icons.event_outlined);
  }

  @override
  String getLabel() {
    return "Events";
  }

  @override
  Widget? floatingActionButton(BuildContext context) => FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EventCreatePage()),
        ),
        child: const Icon(
          Icons.add,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
