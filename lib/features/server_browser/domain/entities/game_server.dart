import 'package:flutter/foundation.dart';

enum GameServerStatus { waiting, playing, empty }

@immutable
class GameServer {
  final int id;
  final String name;
  final String address;
  final int state;
  final int ttl;
  final String mod;
  final String version;
  final String? modTitle;
  final String? modWebsite;
  final String? modIcon32;
  final String map;
  final int players;
  final int maxPlayers;
  final int bots;
  final int spectators;
  final bool protected;
  final bool authentication;
  final String? location;
  final int? started;
  final int? playtime;
  final List<GameServerClient> clients;

  const GameServer({
    required this.id,
    required this.name,
    required this.address,
    required this.state,
    required this.ttl,
    required this.mod,
    required this.version,
    this.modTitle,
    this.modWebsite,
    this.modIcon32,
    required this.map,
    required this.players,
    required this.maxPlayers,
    required this.bots,
    required this.spectators,
    required this.protected,
    required this.authentication,
    this.location,
    this.started,
    this.playtime,
    this.clients = const [],
  });

  GameServerStatus get status {
    if (state == 2) {
      return GameServerStatus.playing;
    }

    if (state == 1 && players > 0) {
      return GameServerStatus.waiting;
    }

    return GameServerStatus.empty;
  }
}

@immutable
class GameServerClient {
  final String name;
  final String fingerprint;
  final String color;
  final String faction;
  final int team;
  final int spawnPoint;
  final bool isAdmin;
  final bool isSpectator;
  final bool isBot;

  const GameServerClient({
    required this.name,
    required this.fingerprint,
    required this.color,
    required this.faction,
    required this.team,
    required this.spawnPoint,
    required this.isAdmin,
    required this.isSpectator,
    required this.isBot,
  });
}
