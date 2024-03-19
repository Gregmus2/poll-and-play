import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/page.dart' as page;
import 'package:poll_and_play/providers/friends.dart';
import 'package:poll_play_proto_gen/public.dart';
import 'package:provider/provider.dart';

class FriendsPage extends StatefulWidget implements page.Page {
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
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<User> friends = [];

  @override
  Widget build(BuildContext context) {
    FriendsProvider provider = Provider.of<FriendsProvider>(context);

    return RefreshIndicator(
      onRefresh: provider.refresh,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchAnchor.bar(
              suggestionsBuilder: (context, controller) {
                if (controller.text.length < 3) {
                  return [const ListTile(title: Text('Type at least 3 letters'))];
                }

                return provider.search(controller.text).then((value) {
                  if (value.isEmpty) {
                    return [const ListTile(title: Text('No results'))];
                  }

                  return List<FriendTile>.generate(
                    value.length,
                    (index) => FriendTile(
                      friend: value[index].friend,
                      isFriend: value[index].isFriend,
                      onAdd: () => controller.closeView(""),
                    ),
                    growable: false,
                  );
                });
              },
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: provider.friends.length,
                itemBuilder: (context, index) => FriendTile(
                      friend: provider.friends[index],
                      isFriend: true,
                    )),
          ],
        ),
      ),
    );
  }
}

class FriendTile extends StatefulWidget {
  const FriendTile({
    super.key,
    required this.friend,
    required this.isFriend,
    this.onAdd,
  });

  final User friend;
  final bool isFriend;
  final VoidCallback? onAdd;

  @override
  State<FriendTile> createState() => _FriendTileState();
}

class _FriendTileState extends State<FriendTile> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    FriendsProvider provider = Provider.of<FriendsProvider>(context, listen: false);

    return ListTile(
      onTap: () {
        // todo open friend profile
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      trailing: widget.isFriend
          ? IconButton(
              icon: isLoading
                  ? const CircularProgressIndicator()
                  : Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                provider.removeFriend(widget.friend.id);
              },
            )
          : IconButton(
              icon: isLoading
                  ? const CircularProgressIndicator()
                  : Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                provider.addFriend(widget.friend.id).then((value) => widget.onAdd?.call());
              },
            ),
      leading: CircleAvatar(
        foregroundImage:
            widget.friend.picture.hasValue() ? CachedNetworkImageProvider(widget.friend.picture.value) : null,
        radius: 30,
      ),
      title: Text(widget.friend.name),
      subtitle: Text(widget.friend.username),
    );
  }
}
