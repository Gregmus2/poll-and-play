import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixnum/src/int64.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/grpc/friends.dart';
import 'package:poll_and_play/pages/page.dart' as page;
import 'package:poll_and_play/providers/friends.dart';
import 'package:poll_and_play/ui/dialog_button.dart';
import 'package:poll_and_play/ui/text_input.dart';
import 'package:poll_play_proto_gen/public.dart';
import 'package:provider/provider.dart';

class FriendsPage extends StatelessWidget implements page.Page {
  const FriendsPage({super.key});

  @override
  Icon getIcon(BuildContext context) {
    return const Icon(Icons.people);
  }

  @override
  Icon getUnselectedIcon(BuildContext context) {
    return const Icon(Icons.people_alt_outlined);
  }

  @override
  String getLabel() {
    return "Friends";
  }

  @override
  Widget? floatingActionButton(BuildContext context) => FloatingActionButton(
        onPressed: () => _showAddUserDialog(context),
        child: const Icon(
          Icons.add,
        ),
      );

  @override
  Widget build(BuildContext context) {
    FriendsProvider provider = Provider.of<FriendsProvider>(context);

    return RefreshIndicator(
      onRefresh: provider.refresh,
      child: ListView.builder(
          itemCount: provider.friends.length,
          itemBuilder: (context, index) => FriendTile(
                friend: provider.friends[index],
                onTap: () {
                  // todo open friend page (reuse user page)
                },
              )),
    );
  }
}

class FriendTile extends StatelessWidget {
  const FriendTile({
    super.key,
    required this.friend,
    required this.onTap,
  });

  final Friend friend;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    FriendsProvider provider = Provider.of<FriendsProvider>(context, listen: false);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          provider.removeFriend(friend.id);
        },
      ),
      leading: CircleAvatar(
        foregroundImage: friend.avatar != "" ? CachedNetworkImageProvider(friend.avatar) : null,
        radius: 30,
      ),
      title: Text(friend.name),
    );
  }
}

Future<void> _showAddUserDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      FriendsClient client = Provider.of<FriendsClient>(context, listen: false);
      TextEditingController nameInput = TextEditingController();

      return AlertDialog(
        content: EntityNameTextInput(
          nameInput: nameInput,
          isValid: (value) => true, // todo add isExists method to friends service to call here
          isValidMessage: "",
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: <Widget>[
          DialogButton(
              text: 'OK',
              onPressed: () {
                // todo replace with email
                client.addFriend(Int64.parseInt(nameInput.text));
                Navigator.pop(context);
              },
              color: Colors.green),
          DialogButton(
              text: 'CANCEL',
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.red)
        ],
      );
    },
  );
}
