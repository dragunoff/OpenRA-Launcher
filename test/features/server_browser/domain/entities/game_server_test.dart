import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';

GameServer gameServerWith({required int state, int players = 0}) {
  return GameServer(
    id: 1,
    name: 'Test Game',
    address: '127.0.0.1:6243',
    state: state,
    ttl: 60,
    mod: 'ra',
    version: 'release-20210321',
    map: 'map-hash',
    players: players,
    maxPlayers: 8,
    bots: 0,
    spectators: 0,
    protected: false,
    authentication: false,
  );
}

void main() {
  group('GameServer.status', () {
    test('returns playing when state is 2', () {
      expect(gameServerWith(state: 2).status, GameServerStatus.playing);
    });

    test('returns waiting when state is 1 and there are players', () {
      final server = gameServerWith(state: 1, players: 3);

      expect(server.status, GameServerStatus.waiting);
    });

    test('returns empty when state is 1 and there are no players', () {
      expect(gameServerWith(state: 1).status, GameServerStatus.empty);
    });

    test('returns empty for any other state', () {
      expect(gameServerWith(state: 0).status, GameServerStatus.empty);
      expect(gameServerWith(state: 3).status, GameServerStatus.empty);
    });
  });
}
