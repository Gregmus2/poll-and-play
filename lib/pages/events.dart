import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/event_create.dart';
import 'package:poll_and_play/pages/page.dart' as page;

class EventsPage extends StatelessWidget implements page.Page {
  const EventsPage({super.key});

  @override
  Icon getIcon(BuildContext context) {
    return Icon(Icons.event, color: Theme.of(context).iconTheme.color);
  }

  @override
  Icon getUnselectedIcon(BuildContext context) {
    return Icon(Icons.event_outlined, color: Theme.of(context).iconTheme.color);
  }

  @override
  String getLabel() {
    return "Events";
  }

  @override
  Widget? floatingActionButton(BuildContext context) => FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventCreatePage()),
        ),
        child: Icon(
          Icons.add,
          color: Theme.of(context).iconTheme.color,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
