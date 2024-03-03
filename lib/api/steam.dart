import 'dart:convert';

import 'package:http/http.dart' as http;

class SteamAPI {
  final String apiKey;
  final String baseUrl = 'https://api.steampowered.com';

  SteamAPI(this.apiKey);

  Future<List<SteamGame>> getGames(String steamId) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/IPlayerService/GetOwnedGames/v0001/?key=$apiKey&steamid=$steamId&include_appinfo=true&include_played_free_games=true&include_free_sub=true&include_extended_appinfo=true&format=json'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final games = data['response']['games'] as List;
      return games.map((game) => SteamGame.fromJson(game)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }
}

class SteamGame {
  final int appId;
  final String name;
  final DateTime lastPlayed;
  final String iconURL;
  final String? capsuleURL;

  SteamGame({
    required this.appId,
    required this.lastPlayed,
    required this.name,
    required this.iconURL,
    this.capsuleURL,
  });

  factory SteamGame.fromJson(Map<String, dynamic> json) {
    return SteamGame(
        appId: json['appid'],
        name: json['name'],
        lastPlayed: DateTime.fromMillisecondsSinceEpoch(json['rtime_last_played'] * 1000),
        iconURL:
            'http://media.steampowered.com/steamcommunity/public/images/apps/${json['appid']}/${json['img_icon_url']}.jpg',
        // todo find better capsules
        capsuleURL: json['capsule_filename'] != null
            ? 'https://steamcdn-a.akamaihd.net/steam/apps/${json['appid']}/${json['capsule_filename']}'
            : null);
  }
}
