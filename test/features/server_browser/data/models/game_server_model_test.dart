import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/server_browser/data/models/game_server_model.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';

void main() {
  final tJson = <String, dynamic>{
    'id': 1,
    'name': 'Red Alert #1',
    'address': '127.0.0.1:6243',
    'state': 1,
    'ttl': 60,
    'mod': 'ra',
    'version': 'release-20210321',
    'modtitle': 'Red Alert',
    'modwebsite': 'https://www.openra.net',
    'modicon32': 'https://www.openra.net/images/icons/ra_32x32.png',
    'map': 'map-hash',
    'players': 2,
    'maxplayers': 8,
    'bots': 1,
    'spectators': 1,
    'protected': true,
    'authentication': false,
    'location': 'Bulgaria',
    'started': '2026-01-06 12:00:00',
    'playtime': 1200,
    'disabled_spawn_points': '2, 4',
    'clients': [
      {
        'name': 'Test Player',
        'fingerprint': '00111101000111100',
        'color': 'A8F0F2',
        'faction': 'Soviet',
        'team': 0,
        'spawnpoint': 1,
        'isadmin': true,
        'isspectator': false,
        'isbot': false,
      },
    ],
  };

  group('GameServerModel.fromJson', () {
    test('parses all server fields', () {
      final server = GameServerModel.fromJson(tJson);

      expect(server, isA<GameServer>());
      expect(server.id, 1);
      expect(server.name, 'Red Alert #1');
      expect(server.address, '127.0.0.1:6243');
      expect(server.state, 1);
      expect(server.ttl, 60);
      expect(server.mod, 'ra');
      expect(server.version, 'release-20210321');
      expect(server.modTitle, 'Red Alert');
      expect(server.modWebsite, 'https://www.openra.net');
      expect(
        server.modIcon32,
        'https://www.openra.net/images/icons/ra_32x32.png',
      );
      expect(server.map, 'map-hash');
      expect(server.players, 2);
      expect(server.maxPlayers, 8);
      expect(server.bots, 1);
      expect(server.spectators, 1);
      expect(server.protected, isTrue);
      expect(server.authentication, isFalse);
      expect(server.location, 'Bulgaria');
      expect(server.started, '2026-01-06 12:00:00');
      expect(server.playtime, 1200);
      expect(server.status, GameServerStatus.waiting);
    });

    test('parses client fields', () {
      final server = GameServerModel.fromJson(tJson);

      expect(server.clients, hasLength(1));
      final client = server.clients.first;
      expect(client.name, 'Test Player');
      expect(client.fingerprint, '00111101000111100');
      expect(client.color, 'A8F0F2');
      expect(client.faction, 'Soviet');
      expect(client.team, 0);
      expect(client.spawnPoint, 1);
      expect(client.isAdmin, isTrue);
      expect(client.isSpectator, isFalse);
      expect(client.isBot, isFalse);
    });

    test('tolerates missing optional fields', () {
      final server = GameServerModel.fromJson({
        'id': 2,
        'name': 'Dune 2000 Lobby',
        'address': '10.0.0.5:6243',
        'state': 1,
        'ttl': 15,
        'mod': 'd2k',
        'map': 'map-hash',
      });

      expect(server.modTitle, isNull);
      expect(server.location, isNull);
      expect(server.started, isNull);
      expect(server.playtime, isNull);
      expect(server.clients, isEmpty);
      expect(server.protected, isFalse);
      expect(server.authentication, isFalse);
      expect(server.players, 0);
      expect(server.maxPlayers, 0);
    });
  });

  group('GameServerModel.parse', () {
    test('yields Right for a valid server', () async {
      final either = await GameServerModel.parse(tJson).run();

      expect(either, isA<Right<GameServerParseFailure, GameServerModel>>());
      expect(either.getRight().toNullable()!.name, 'Red Alert #1');
    });

    test('yields Left with the parse error for an invalid server', () async {
      final either = await GameServerModel.parse({'id': 'not-an-int'}).run();

      final failure = either.getLeft().toNullable();
      expect(failure, isA<GameServerParseFailure>());
      expect(failure!.exception, isA<TypeError>());
    });
  });
}
