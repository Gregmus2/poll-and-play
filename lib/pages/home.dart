import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/events.dart';
import 'package:poll_and_play/pages/friends.dart';
import 'package:poll_and_play/pages/games.dart';
import 'package:poll_and_play/pages/groups.dart';
import 'package:poll_and_play/pages/page.dart' as page;
import 'package:poll_and_play/pages/profile.dart';

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
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
        ),
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
