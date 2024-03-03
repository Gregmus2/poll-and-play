import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/events.dart';
import 'package:poll_and_play/pages/friends.dart';
import 'package:poll_and_play/pages/games.dart';
import 'package:poll_and_play/pages/groups.dart';
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
    GroupsPage(),
    FriendsPage(),
    EventsPage(),
    GamesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(FirebaseAuth.instance.currentUser!.displayName ?? "", style: Theme.of(context).textTheme.titleLarge),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.logout, color: Theme.of(context).iconTheme.color),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                stateProvider.user = null;
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
          indicatorColor: colorScheme.primary,
          selectedIndex: pageIndex,
          backgroundColor: colorScheme.background,
          elevation: 1,
          destinations: List.generate(
              _pages.length,
              (index) => NavigationDestination(
                  icon: pageIndex == index ? _pages[index].getIcon(context) : _pages[index].getUnselectedIcon(context),
                  label: _pages[index].getLabel())),
        ));
  }
}
