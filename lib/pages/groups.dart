import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poll_and_play/pages/group.dart';
import 'package:poll_and_play/pages/page.dart' as page;
import 'package:poll_and_play/providers/groups.dart';
import 'package:poll_and_play/ui/dialog_button.dart';
import 'package:poll_and_play/ui/text_input.dart';
import 'package:poll_play_proto_gen/public.dart';
import 'package:provider/provider.dart';

class GroupsPage extends StatelessWidget implements page.Page {
  const GroupsPage({super.key});

  @override
  Icon getIcon(BuildContext context) {
    return Icon(Icons.group_add_rounded, color: Theme.of(context).iconTheme.color);
  }

  @override
  Icon getUnselectedIcon(BuildContext context) {
    return Icon(Icons.group_add_outlined, color: Theme.of(context).iconTheme.color);
  }

  @override
  String getLabel() {
    return "Groups";
  }

  @override
  Widget? floatingActionButton(BuildContext context) => FloatingActionButton(
        onPressed: () => _showCreateGroupDialog(context),
        child: Icon(
          Icons.add,
          color: Theme.of(context).iconTheme.color,
        ),
      );

  @override
  Widget build(BuildContext context) {
    GroupsProvider provider = Provider.of<GroupsProvider>(context);

    return ListView.builder(
        itemCount: provider.groups.length,
        itemBuilder: (context, index) => GroupTile(
              group: provider.groups[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroupPage(group: provider.groups[index])),
                );
              },
            ));
  }

  void _showCreateGroupDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        TextEditingController nameInput = TextEditingController();
        ThemeData theme = Theme.of(context);
        GroupsProvider provider = Provider.of<GroupsProvider>(context);

        return AlertDialog(
          title: Text(
            "Create Group",
            style: theme.textTheme.titleLarge,
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
                color: Colors.green),
            DialogButton(
                text: "Cancel",
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.red),
          ],
        );
      },
    );
  }
}

class GroupTile extends StatelessWidget {
  const GroupTile({
    super.key,
    required this.group,
    required this.onTap,
  });

  final Group group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        group.name,
        style: Theme.of(context).textTheme.bodyMedium,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
      onTap: onTap,
    );
  }
}
