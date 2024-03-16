import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/providers/groups.dart';
import 'package:poll_and_play/providers/state.dart';
import 'package:poll_play_proto_gen/public.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatelessWidget {
  final Group group;

  const GroupPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          group.name,
        ),
      ),
      body: ListView.builder(
          itemCount: group.members.length,
          itemBuilder: (context, index) => MemberTile(
            member: group.members[index],
          )),
    );
  }
}

class MemberTile extends StatelessWidget {
  final GroupMember member;

  const MemberTile({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    GroupsProvider provider = Provider.of<GroupsProvider>(context, listen: false);
    StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        foregroundImage: member.user.picture != "" ? CachedNetworkImageProvider(member.user.picture) : null,
        radius: 30,
      ),
      trailing: stateProvider.user!.id != member.user.id ? IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          // todo remove member
        },
      ) : null,
      title: Text(member.user.name),
    );
  }
}
