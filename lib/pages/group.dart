import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/friends.dart';
import 'package:poll_and_play/pages/groups.dart';
import 'package:poll_and_play/providers/groups.dart';
import 'package:poll_and_play/providers/state.dart';
import 'package:poll_and_play/ui/dialog_button.dart';
import 'package:poll_and_play/ui/loading_icon_button.dart';
import 'package:poll_and_play/ui/text_input.dart';
import 'package:poll_play_proto_gen/public.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  final $fixnum.Int64 groupID;

  const GroupPage({super.key, required this.groupID});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    StateProvider stateProvider = Provider.of<StateProvider>(context);
    GroupsProvider provider = Provider.of<GroupsProvider>(context);
    final group = provider.groups.firstWhere((element) => element.id == widget.groupID);

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
        actions: group.owner == stateProvider.user?.id
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditNameDialog(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                  onPressed: () {
                    deleteGroupWithConfirmation(context, group);
                    Navigator.pop(context);
                  },
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MembersSearch(groupID: group.id),
            MembersList(groupID: group.id),
          ],
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    GroupsProvider provider = Provider.of<GroupsProvider>(context, listen: false);
    final group = provider.groups.firstWhere((element) => element.id == widget.groupID);
    TextEditingController nameInput = TextEditingController();
    nameInput.text = group.name;

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
                provider.updateGroup(group.id, nameInput.text);
                setState(() {
                  group.name = nameInput.text;
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

class MembersList extends StatelessWidget {
  const MembersList({
    super.key,
    required this.groupID,
  });

  final $fixnum.Int64 groupID;

  @override
  Widget build(BuildContext context) {
    GroupsProvider provider = Provider.of<GroupsProvider>(context);
    final group = provider.groups.firstWhere((element) => element.id == groupID);

    return ListView.builder(
        shrinkWrap: true,
        itemCount: group.members.length,
        itemBuilder: (context, index) => MemberTile(
              member: group.members[index],
              group: group,
            ));
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

    // todo mark invited members separately
    // todo add refresh
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        foregroundImage: member.user.picture.hasValue() ? CachedNetworkImageProvider(member.user.picture.value) : null,
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

class MembersSearch extends StatelessWidget {
  final $fixnum.Int64 groupID;

  const MembersSearch({
    super.key,
    required this.groupID,
  });

  @override
  Widget build(BuildContext context) {
    GroupsProvider provider = Provider.of<GroupsProvider>(context, listen: false);

    return SearchAnchor.bar(
      viewHintText: 'Search friends to invite',
      suggestionsBuilder: (context, controller) {
        return provider.searchMembers(groupID, controller.text).then((value) {
          if (value.isEmpty) {
            return [const ListTile(title: Text('No results'))];
          }

          return List<FriendTile>.generate(
            value.length,
            (index) => FriendTile(
              friend: value[index],
              button: LoadingIconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    provider.inviteToGroup(groupID, value[index].id).then((value) => controller.closeView(""));
                  }),
            ),
            growable: false,
          );
        });
      },
    );
  }
}
