import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/groups.dart';
import 'package:poll_and_play/providers/groups.dart';
import 'package:poll_and_play/providers/state.dart';
import 'package:poll_and_play/ui/dialog_button.dart';
import 'package:poll_and_play/ui/text_input.dart';
import 'package:poll_play_proto_gen/public.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  final Group group;

  const GroupPage({super.key, required this.group});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    StateProvider stateProvider = Provider.of<StateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          widget.group.name,
        ),
        actions: widget.group.owner == stateProvider.user?.id ? [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditNameDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
            onPressed: () {
              deleteGroupWithConfirmation(context, widget.group);
              Navigator.pop(context);
            },
          ),
        ] : null,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // todo the same as for friends
          // _showInviteMemberDialog(context);
        },
        child: const Icon(
          Icons.person_add,
        ),
      ),
      body: ListView.builder(
          itemCount: widget.group.members.length,
          itemBuilder: (context, index) => MemberTile(
                member: widget.group.members[index],
                group: widget.group,
              )),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    TextEditingController nameInput = TextEditingController();
    nameInput.text = widget.group.name;
    GroupsProvider provider = Provider.of<GroupsProvider>(context, listen: false);

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Edit Group Name",
          ),
          content: EntityNameTextInput(
            nameInput: nameInput,
            isValid: (value) => true,
            isValidMessage: '',
          ),
          actions: [
            DialogButton(
              text: 'Save',
              onPressed: () {
                provider.updateGroup(widget.group.id, nameInput.text);
                setState(() {
                  widget.group.name = nameInput.text;
                });

                Navigator.pop(context);
              },
              color: Theme.of(context).colorScheme.primary,
            ),
            DialogButton(
              text: 'Cancel',
              onPressed: () {
                Navigator.pop(context);
              },
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        );
      },
    );
  }
}

class MemberTile extends StatelessWidget {
  final GroupMember member;
  final Group group;

  const MemberTile({
    super.key,
    required this.member,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        foregroundImage: member.user.picture != "" ? CachedNetworkImageProvider(member.user.picture) : null,
        radius: 30,
      ),
      trailing: stateProvider.user!.id != member.user.id && group.owner == stateProvider.user?.id
          ? IconButton(
              icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
              onPressed: () {
                _removeMemberWithConfirmation(context);
              },
            )
          : null,
      title: Text(member.user.name),
    );
  }

  Future<void> _removeMemberWithConfirmation(BuildContext context) {
    GroupsProvider provider = Provider.of<GroupsProvider>(context, listen: false);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove member'),
          content: const Text('Do you want to remove this member from the group?'),
          actions: <Widget>[
            DialogButton(
              text: 'Remove',
              onPressed: () {
                provider.removeUserFromGroup(group.id, member.user.id).then((value) => Navigator.pop(context));
              },
              color: Theme.of(context).colorScheme.error,
            ),
            DialogButton(
              text: 'Cancel',
              onPressed: () {
                Navigator.pop(context);
              },
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        );
      },
    );
  }
}
