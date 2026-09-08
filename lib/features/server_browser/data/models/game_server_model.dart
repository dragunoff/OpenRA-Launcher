import 'package:flutter/foundation.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';

@immutable
class GameServerModel extends GameServer {
  const GameServerModel({
    required super.id,
    required super.name,
    required super.address,
    required super.state,
    required super.ttl,
    required super.mod,
    required super.version,
    super.modTitle,
    super.modWebsite,
    super.modIcon32,
    required super.map,
    required super.players,
    required super.maxPlayers,
    required super.bots,
    required super.spectators,
    required super.protected,
    required super.authentication,
    super.location,
    super.started,
    super.playtime,
    super.clients,
  });

  factory GameServerModel.fromJson(Map<String, dynamic> json) {
    final clientsRaw = json['clients'];

    return GameServerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      state: json['state'] as int,
      ttl: json['ttl'] as int,
      mod: json['mod'] as String? ?? '',
      version: json['version'] as String? ?? '',
      modTitle: json['modtitle'] as String?,
      modWebsite: json['modwebsite'] as String?,
      modIcon32: json['modicon32'] as String?,
      map: json['map'] as String? ?? '',
      players: json['players'] as int? ?? 0,
      maxPlayers: json['maxplayers'] as int? ?? 0,
      bots: json['bots'] as int? ?? 0,
      spectators: json['spectators'] as int? ?? 0,
      protected: json['protected'] as bool? ?? false,
      authentication: json['authentication'] as bool? ?? false,
      location: json['location'] as String?,
      started: json['started'] as int?,
      playtime: json['playtime'] as int?,
      clients: clientsRaw is List
          ? clientsRaw
                .whereType<Map<String, dynamic>>()
                .map(GameServerClientModel.fromJson)
                .toList()
          : const [],
    );
  }
}

@immutable
class GameServerClientModel extends GameServerClient {
  const GameServerClientModel({
    required super.name,
    required super.fingerprint,
    required super.color,
    required super.faction,
    required super.team,
    required super.spawnPoint,
    required super.isAdmin,
    required super.isSpectator,
    required super.isBot,
  });

  factory GameServerClientModel.fromJson(Map<String, dynamic> json) {
    return GameServerClientModel(
      name: json['name'] as String? ?? '',
      fingerprint: json['fingerprint'] as String? ?? '',
      color: json['color'] as String? ?? '',
      faction: json['faction'] as String? ?? '',
      team: json['team'] as int? ?? 0,
      spawnPoint: json['spawnpoint'] as int? ?? 0,
      isAdmin: json['isadmin'] as bool? ?? false,
      isSpectator: json['isspectator'] as bool? ?? false,
      isBot: json['isbot'] as bool? ?? false,
    );
  }
}
