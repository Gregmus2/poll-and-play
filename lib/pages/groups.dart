import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/group.dart';
import 'package:poll_and_play/pages/page.dart' as page;
import 'package:poll_and_play/providers/groups.dart';
import 'package:poll_and_play/providers/state.dart';
import 'package:poll_and_play/ui/dialog_button.dart';
import 'package:poll_and_play/ui/text_input.dart';
import 'package:poll_play_proto_gen/public.dart';
import 'package:provider/provider.dart';

class GroupsPage extends StatelessWidget implements page.Page {
  const GroupsPage({super.key});

  @override
  Icon getIcon(BuildContext context) {
    return const Icon(Icons.group_add_rounded);
  }

  @override
  Icon getUnselectedIcon(BuildContext context) {
    return const Icon(Icons.group_add_outlined);
  }

  @override
  String getLabel() {
    return "Groups";
  }

  @override
  Widget? floatingActionButton(BuildContext context) => FloatingActionButton(
        onPressed: () => _showCreateGroupDialog(context),
        child: const Icon(
          Icons.add,
        ),
      );

  @override
  Widget build(BuildContext context) {
    GroupsProvider provider = Provider.of<GroupsProvider>(context);

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        physics: const BouncingScrollPhysics(),
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad
        },
      ),
      child: RefreshIndicator(
        onRefresh: provider.refresh,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: _generateGroups(context),
        ),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        TextEditingController nameInput = TextEditingController();
        GroupsProvider provider = Provider.of<GroupsProvider>(context);

        return AlertDialog(
          title: const Text(
            "Create Group",
          ),
          content: EntityNameTextInput(
            nameInput: nameInput,
            isValid: (value) => true, // todo add isExists method to groups service to call here
            isValidMessage: "",
          ),
          actions: <Widget>[
            DialogButton(
                text: "Create",
                onPressed: () {
                  provider.createGroup(nameInput.text);

                  Navigator.pop(context);
                },
                color: Theme.of(context).colorScheme.primary),
            DialogButton(
                text: "Cancel",
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Theme.of(context).colorScheme.error),
          ],
        );
      },
    );
  }

  List<Widget> _generateGroups(BuildContext context) {
    GroupsProvider provider = Provider.of<GroupsProvider>(context);
    List<Group> groupsAsMember =
        provider.groups.where((element) => element.status == GroupStatus.GROUP_STATUS_MEMBER).toList();

    List<Widget> children = List<Widget>.generate(
        groupsAsMember.length,
        (index) => GroupTile(
              group: groupsAsMember[index],
            ));

    children.add(Card(
      elevation: 3,
      child: Column(
        children: _generateInvitations(context),
      ),
    ));

    return children;
  }

  List<Widget> _generateInvitations(BuildContext context) {
    GroupsProvider provider = Provider.of<GroupsProvider>(context);
    List<Group> groupsInvited =
        provider.groups.where((element) => element.status == GroupStatus.GROUP_STATUS_INVITED).toList();

    List<Widget> groupsInvitedList = List<Widget>.generate(
        groupsInvited.length,
        (index) => GroupTile(
              group: groupsInvited[index],
            ));

    groupsInvitedList.insert(
        0,
        ListTile(
            title: Center(
                child: Text(
          "Invitations",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary),
        ))));

    return groupsInvitedList;
  }
}

class GroupTile extends StatelessWidget {
  const GroupTile({
    super.key,
    required this.group,
  });

  final Group group;

  @override
  Widget build(BuildContext context) {
    StateProvider stateProvider = Provider.of<StateProvider>(context);
    Color redColor = Theme.of(context).colorScheme.error;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        group.name,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: group.owner == stateProvider.user?.id
          ? IconButton(
              icon: Icon(Icons.delete, color: redColor),
              onPressed: () {
                deleteGroupWithConfirmation(context, group);
              })
          : IconButton(
              icon: Icon(Icons.exit_to_app, color: redColor),
              onPressed: () {
                // todo leave group
              }),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GroupPage(groupID: group.id)),
        );
      },
    );
  }
}

Future<void> deleteGroupWithConfirmation(BuildContext context, Group group) {
  GroupsProvider provider = Provider.of<GroupsProvider>(context, listen: false);

  return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Delete Group"),
            content: const Text("Are you sure you want to delete this group?"),
            actions: <Widget>[
              DialogButton(
                  text: "Delete",
                  onPressed: () {
                    provider.deleteGroup(group.id).then((value) => Navigator.pop(context));
                  },
                  color: Theme.of(context).colorScheme.error),
              DialogButton(
                  text: "Cancel",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Theme.of(context).colorScheme.primary),
            ],
          ));
}
