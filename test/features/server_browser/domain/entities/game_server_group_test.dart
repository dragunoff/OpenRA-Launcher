import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server_group.dart';

void main() {
  GameServer server({
    int id = 1,
    String mod = 'ra',
    String? modTitle,
    String version = 'release-20210321',
    int state = 1,
    int players = 0,
    int spectators = 0,
    String? started,
    String? modIcon32,
    String? modWebsite,
  }) {
    return GameServer(
      id: id,
      name: 'Game $id',
      address: '127.0.0.1:$id',
      state: state,
      ttl: 60,
      mod: mod,
      version: version,
      modTitle: modTitle,
      modWebsite: modWebsite,
      modIcon32: modIcon32,
      map: 'map-hash',
      players: players,
      maxPlayers: 8,
      bots: 0,
      spectators: spectators,
      protected: false,
      authentication: false,
      location: 'Bulgaria',
      started: started,
    );
  }

  group('groupServersByModAndVersion', () {
    test('groups servers by mod title and version', () {
      final groups = groupServersByModAndVersion([
        server(id: 1, mod: 'ra', modTitle: 'Red Alert'),
        server(id: 2, mod: 'd2k', modTitle: 'Dune 2000'),
        server(id: 3, mod: 'ra', modTitle: 'Red Alert', version: 'playtest'),
        server(id: 4, mod: 'ra', modTitle: 'Red Alert'),
      ]);

      expect(groups, hasLength(3));
      final redAlert = groups.singleWhere(
        (g) => g.title == 'Red Alert' && g.version == 'release-20210321',
      );
      expect(redAlert.title, 'Red Alert');
      expect(redAlert.servers, hasLength(2));
    });

    test('falls back to a known title for official mods', () {
      final groups = groupServersByModAndVersion([
        server(mod: 'ra'),
        server(mod: 'cnc'),
        server(mod: 'd2k', version: 'x'),
      ]);

      expect(
        groups.map((g) => g.title),
        unorderedEquals(['Red Alert', 'Tiberian Dawn', 'Dune 2000']),
      );
    });

    test('labels unknown mods without a title', () {
      final groups = groupServersByModAndVersion([server(mod: 'custom-mod')]);

      expect(groups.single.title, 'Unknown Mod "custom-mod"');
    });

    test('truncates long mod titles', () {
      final title = 'x' * (maxModTitleLength + 10);
      final groups = groupServersByModAndVersion([server(modTitle: title)]);

      expect(groups.single.title, hasLength(maxModTitleLength));
    });

    test('carries the mod icon and website from the server', () {
      final groups = groupServersByModAndVersion([
        server(
          mod: 'ra',
          modTitle: 'Red Alert',
          modIcon32: 'icon.png',
          modWebsite: 'https://openra.net',
        ),
      ]);

      expect(groups.single.iconUrl, 'icon.png');
      expect(groups.single.website, 'https://openra.net');
    });

    test('sums players and spectators as the player count', () {
      final groups = groupServersByModAndVersion([
        server(id: 1, players: 2, spectators: 1),
        server(id: 2, players: 3, spectators: 0),
      ]);

      expect(groups.single.playerCount, 6);
    });

    test('orders groups by player count with favorites first', () {
      final groups = groupServersByModAndVersion(
        [
          server(id: 1, mod: 'ra', players: 8),
          server(id: 2, mod: 'd2k', players: 1),
          server(id: 3, mod: 'cnc', players: 4),
        ],
        favoriteModKeys: {'cnc-release-20210321'},
      );

      expect(groups.map((g) => g.mod), orderedEquals(['cnc', 'ra', 'd2k']));
      expect(groups.map((g) => g.playerCount), orderedEquals([4, 8, 1]));
      expect(groups[0].isFavorite, isTrue);
    });

    test('favorites come first even with fewer players', () {
      final groups = groupServersByModAndVersion(
        [
          server(id: 1, mod: 'ra', players: 8),
          server(id: 2, mod: 'd2k', players: 1),
        ],
        favoriteModKeys: {'d2k-release-20210321'},
      );

      expect(groups.map((g) => g.mod), orderedEquals(['d2k', 'ra']));
    });

    test('orders groups in a section by player count, most played first', () {
      final groups = groupServersByModAndVersion([
        server(id: 1, mod: 'ra', players: 1),
        server(id: 2, mod: 'cnc', players: 8),
        server(id: 3, mod: 'd2k', players: 4),
      ]);

      expect(groups.map((g) => g.playerCount), orderedEquals([8, 4, 1]));
    });

    test('sorts dev groups after the rest, even when busier', () {
      final groups = groupServersByModAndVersion([
        server(id: 1, mod: 'ra', players: 4, version: 'release-20210321'),
        server(id: 2, mod: 'cnc', players: 9, version: '{DEV_VERSION}'),
        server(id: 3, mod: 'd2k', players: 1, version: 'release-20250330'),
      ]);

      expect(groups.map((g) => g.mod), orderedEquals(['ra', 'd2k', 'cnc']));
      expect(groups.last.isDev, isTrue);
    });

    test('keeps favorited dev groups in the favorites section', () {
      final groups = groupServersByModAndVersion(
        [
          server(id: 1, mod: 'ra', players: 8, version: 'release-20210321'),
          server(id: 2, mod: 'cnc', players: 2, version: '{DEV_VERSION}'),
          server(id: 3, mod: 'd2k', players: 4, version: 'release-20250330'),
        ],
        favoriteModKeys: {'cnc-{DEV_VERSION}'},
      );

      expect(groups.first.mod, 'cnc');
      expect(groups.first.isFavorite, isTrue);
      expect(groups.first.isDev, isTrue);
    });

    test('isFavorite matches the mod and version of a favorite key', () {
      final groups = groupServersByModAndVersion(
        [server(id: 1, mod: 'ra', version: 'release-20210321')],
        favoriteModKeys: {'ra-release-20210321'},
      );

      expect(groups.single.isFavorite, isTrue);
      expect(groups.single.favoriteKey, 'ra-release-20210321');
    });

    test('does not mark a group as favorite when the key does not match', () {
      final groups = groupServersByModAndVersion(
        [
          server(id: 1, mod: 'ra', version: 'release-20210321'),
          server(id: 2, mod: 'ra', version: 'playtest-20210314'),
        ],
        favoriteModKeys: {'ra-release-20210321'},
      );

      final favorite = groups.singleWhere(
        (g) => g.version == 'release-20210321',
      );
      final other = groups.singleWhere((g) => g.version == 'playtest-20210314');
      expect(favorite.isFavorite, isTrue);
      expect(other.isFavorite, isFalse);
    });

    test('marks a group as hidden when its key is in hiddenModKeys', () {
      final groups = groupServersByModAndVersion(
        [
          server(id: 1, mod: 'ra', version: 'release-20210321'),
          server(id: 2, mod: 'ra', version: 'playtest-20210314'),
        ],
        hiddenModKeys: {'ra-release-20210321'},
      );

      final hidden = groups.singleWhere((g) => g.version == 'release-20210321');
      final other = groups.singleWhere((g) => g.version == 'playtest-20210314');
      expect(hidden.isHidden, isTrue);
      expect(other.isHidden, isFalse);
    });

    test('sorts servers within a group as the in-game browser does', () {
      final groups = groupServersByModAndVersion([
        server(id: 1, state: 1, players: 0, spectators: 2),
        server(id: 2, state: 2, players: 4, started: '2026-01-06 12:00:00'),
        server(id: 3, state: 1, players: 5),
        server(id: 4, state: 0, players: 0),
      ]);

      expect(
        groups.single.servers.map((s) => s.id),
        orderedEquals([3, 1, 2, 4]),
      );
    });

    test('orders in-progress games by start time, newest first', () {
      final groups = groupServersByModAndVersion([
        server(id: 1, state: 2, started: '2026-01-06 09:00:00'),
        server(id: 2, state: 2, started: '2026-01-06 12:00:00'),
        server(id: 3, state: 2, started: '2026-01-06 10:00:00'),
      ]);

      expect(groups.single.servers.map((s) => s.id), orderedEquals([2, 3, 1]));
    });
  });
}
