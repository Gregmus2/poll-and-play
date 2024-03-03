import 'package:flutter/material.dart';
import 'package:poll_and_play/api/steam.dart';
import 'package:poll_and_play/pages/page.dart' as page;
import 'package:poll_and_play/providers/games.dart';
import 'package:provider/provider.dart';

class GamesPage extends StatelessWidget implements page.Page {
  const GamesPage({super.key});

  @override
  Icon getIcon(BuildContext context) {
    return Icon(Icons.gamepad, color: Theme.of(context).iconTheme.color);
  }

  @override
  Icon getUnselectedIcon(BuildContext context) {
    return const Icon(Icons.gamepad_outlined, color: Colors.white);
  }

  @override
  String getLabel() {
    return "Games";
  }

  @override
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    GamesProvider gamesProvider = Provider.of<GamesProvider>(context);

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
      ),
      itemCount: gamesProvider.games.length,
      itemBuilder: (context, index) => GameTile(game: gamesProvider.games[index]),
    );
  }
}

class GameTile extends StatelessWidget {
  final SteamGame game;
  final bool isSelected;

  const GameTile({
    super.key,
    required this.game,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: isSelected ? BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ) : BorderSide.none,
      ),
      elevation: 5,
      // todo add friends icons that have this game, name of the game
      child: Image.network(game.capsuleURL ?? game.iconURL, fit: BoxFit.fill),
    );
  }
}
