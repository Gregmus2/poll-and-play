import 'package:flutter/material.dart';
import 'package:poll_play_proto_gen/public.dart';

class GroupPage extends StatelessWidget {
  final Group group;

  const GroupPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          group.name,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: const Center(
        child: Text('Group'),
      ),
    );
  }
}
