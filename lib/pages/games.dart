import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:poll_and_play/pages/page.dart' as page;
import 'package:poll_and_play/providers/games.dart';
import 'package:poll_and_play/providers/state.dart';
import 'package:poll_and_play/ui/dialog_button.dart';
import 'package:poll_and_play/ui/text_input.dart';
import 'package:poll_play_proto_gen/public.dart';
import 'package:provider/provider.dart';

class GamesPage extends StatelessWidget implements page.Page {
  const GamesPage({super.key});

  @override
  Icon getIcon(BuildContext context) {
    return const Icon(Icons.gamepad);
  }

  @override
  Icon getUnselectedIcon(BuildContext context) {
    return const Icon(Icons.gamepad_outlined);
  }

  @override
  String getLabel() {
    return "Games";
  }

  @override
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    StateProvider stateProvider = Provider.of<StateProvider>(context);

    // todo local flutter search
    return stateProvider.user!.steamId.hasValue() ? const ListGames() : Center(
      // todo add reconnect option
      child: ElevatedButton(
        onPressed: () {
          showConnectSteamDialog(context);
        },
        child: const Text("Connect Steam"),
      ),
    );
  }

  void showConnectSteamDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        StateProvider state = Provider.of<StateProvider>(context, listen: false);
        GamesProvider gamesProvider = Provider.of<GamesProvider>(context, listen: false);
        TextEditingController nameInput = TextEditingController();

        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Please enter your steam ID\n\nYou can find it in your profile URL\nhttps://steamcommunity.com/profiles/YOUR_STEAM_ID/"),
              EntityNameTextInput(
                nameInput: nameInput,
                isValid: (value) => true,
                isValidMessage: "",
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: <Widget>[
            DialogButton(
                text: 'OK',
                onPressed: () {
                  gamesProvider.connectSteam(nameInput.text).then((value) {
                    state.initUser();

                    Navigator.pop(context);
                  });
                },
                color: Theme.of(context).colorScheme.primary),
            DialogButton(
                text: 'CANCEL',
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Theme.of(context).colorScheme.error)
          ],
        );
      },
    );
  }
}

class ListGames extends StatelessWidget {
  const ListGames({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GamesProvider gamesProvider = Provider.of<GamesProvider>(context);

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
        onRefresh: gamesProvider.refresh,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.7,
          ),
          itemCount: gamesProvider.games.length,
          itemBuilder: (context, index) => GameTile(game: gamesProvider.games[index]),
        ),
      ),
    );
  }
}

class GameTile extends StatelessWidget {
  final GameWithStat game;
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
        side: isSelected
            ? BorderSide(
                color: Theme.of(context).indicatorColor,
                width: 2,
              )
            : BorderSide.none,
      ),
      elevation: 5,
      // todo add friends icons that have this game, name of the game
      child: kIsWeb
          ? Image.network(
              game.game.capsuleUrl,
              fit: BoxFit.fill,
            )
          : CachedNetworkImage(
              imageUrl: game.game.capsuleUrl,
              fit: BoxFit.fill,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
    );
  }
}
