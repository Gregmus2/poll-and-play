import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/events.dart';
import 'package:poll_and_play/pages/friends.dart';
import 'package:poll_and_play/pages/games.dart';
import 'package:poll_and_play/pages/groups.dart';
import 'package:poll_and_play/pages/login.dart';
import 'package:poll_and_play/pages/page.dart' as page;
import 'package:poll_and_play/providers/state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 1;
  final List<page.Page> _pages = [
    const GroupsPage(),
    const FriendsPage(),
    const EventsPage(),
    const GamesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CachedNetworkImage(
                  imageUrl: FirebaseAuth.instance.currentUser!.photoURL ?? "",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator()),
              const SizedBox(width: 10),
              Text(FirebaseAuth.instance.currentUser!.displayName ?? ""),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                stateProvider.resetUser();
                googleSignIn.disconnect();
              },
            ),
          ],
        ),
        floatingActionButton: _pages[pageIndex].floatingActionButton(context),
        body: IndexedStack(
          index: pageIndex,
          children: _pages,
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) => setState(() {
            pageIndex = index;
          }),
          selectedIndex: pageIndex,
          elevation: 1,
          destinations: List.generate(
              _pages.length,
              (index) => NavigationDestination(
                  icon: pageIndex == index ? _pages[index].getIcon(context) : _pages[index].getUnselectedIcon(context),
                  label: _pages[index].getLabel())),
        ));
  }
}
