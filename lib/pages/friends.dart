import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/page.dart' as page;
import 'package:poll_and_play/providers/friends.dart';
import 'package:poll_and_play/ui/cross_platform_refresh.dart';
import 'package:poll_and_play/ui/loading_icon_button.dart';
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

    return CrossPlatformRefreshIndicator(
      onRefresh: provider.refresh,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const FriendsSearch(),
            Expanded(
              child: ListFriends(friends: provider.friends),
            ),
          ],
        ),
      ),
    );
  }
}

class ListFriends extends StatelessWidget {
  const ListFriends({
    super.key,
    required this.friends,
  });

  final List<User> friends;

  @override
  Widget build(BuildContext context) {
    FriendsProvider provider = Provider.of<FriendsProvider>(context, listen: false);

    return ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) => FriendTile(
            friend: friends[index],
            button: LoadingIconButton(
              icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
              onPressed: () => provider.removeFriend(friends[index].id),
            )));
  }
}

class FriendsSearch extends StatelessWidget {
  const FriendsSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    FriendsProvider provider = Provider.of<FriendsProvider>(context, listen: false);

    return SearchAnchor.bar(
      barTrailing: const [Icon(Icons.person_add_alt_1)],
      viewHintText: 'Search users to add',
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
              button: value[index].isFriend
                  ? LoadingIconButton(
                      icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                      onPressed: () => provider.removeFriend(value[index].friend.id))
                  : LoadingIconButton(
                      icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                      onPressed: () =>
                          provider.addFriend(value[index].friend.id).then((value) => controller.closeView("")),
                    ),
            ),
            growable: false,
          );
        });
      },
    );
  }
}

class FriendTile extends StatelessWidget {
  const FriendTile({
    super.key,
    required this.friend,
    required this.button,
  });

  final User friend;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // todo open user profile
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      trailing: button,
      leading: CircleAvatar(
        foregroundImage: friend.picture.hasValue() ? CachedNetworkImageProvider(friend.picture.value) : null,
        radius: 30,
      ),
      title: Text(friend.name),
      subtitle: Text(friend.username),
    );
  }
}
