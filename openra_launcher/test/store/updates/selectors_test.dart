import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/updates/selectors.dart';

void main() {
  group('Update selectors', () {
    Mod mod(String version, {String id = 'test'}) => Mod(
          key: '$id-$version',
          id: id,
          version: version,
          title: 'Test Mod',
          launchPath: '/launch',
          launchArgs: const [''],
        );

    Release rel(
      int id,
      String version, {
      bool isPlaytest = false,
      String modId = 'test',
    }) =>
        Release(
          modId: modId,
          id: id,
          name: '${isPlaytest ? 'Playtest' : 'Release'} $version',
          version: version,
          isPlaytest: isPlaytest,
          htmlUrl: 'https://example.com/$version',
        );

    final stableV100 = mod('1.0.0');
    final stableV090 = mod('0.9.0');
    final playtestV110 = mod('1.1.0');

    group('selectLatestReleaseForMod', () {
      test('returns the latest non-playtest release by id', () {
        final state = AppState(
          mods: {stableV100},
          releases: {
            rel(10, '1.0.1'),
            rel(12, '1.0.2'),
            rel(11, '1.1.0', isPlaytest: true),
          },
        );

        expect(selectLatestReleaseForMod(state, 'test')!.version, '1.0.2');
      });

      test('returns null when no release exists for the mod', () {
        final state = AppState(
          mods: {stableV100},
          releases: {rel(10, '1.0.1', modId: 'other')},
        );

        expect(selectLatestReleaseForMod(state, 'test'), isNull);
      });
    });

    group('selectLatestPlaytestForMod', () {
      test('returns the latest playtest release by id', () {
        final state = AppState(
          mods: {stableV100},
          releases: {
            rel(20, '1.1.0', isPlaytest: true),
            rel(21, '1.2.0', isPlaytest: true),
            rel(22, '1.3.0'),
          },
        );

        expect(selectLatestPlaytestForMod(state, 'test')!.version, '1.2.0');
      });

      test('returns null when no playtest exists for the mod', () {
        final state = AppState(mods: {stableV100}, releases: {});

        expect(selectLatestPlaytestForMod(state, 'test'), isNull);
      });
    });


    group('selectCurrentModReleaseType', () {
      test('returns release when installed version matches latest release',
          () {
        final state = AppState(
          mods: {stableV100},
          releases: {rel(41, '1.0.0')},
        );

        expect(
          selectCurrentModReleaseType(state, stableV100),
          ModReleaseType.release,
        );
      });

      test('returns playtest when installed version matches latest playtest',
          () {
        final state = AppState(
          mods: {playtestV110},
          releases: {rel(42, '1.1.0', isPlaytest: true)},
        );

        expect(
          selectCurrentModReleaseType(state, playtestV110),
          ModReleaseType.playtest,
        );
      });

      test('takes precedence of release over playtest on equal versions', () {
        final state = AppState(
          mods: {mod('1.0.0')},
          releases: {
            rel(43, '1.0.0'),
            rel(44, '1.0.0', isPlaytest: true),
          },
        );

        expect(
          selectCurrentModReleaseType(state, mod('1.0.0')),
          ModReleaseType.release,
        );
      });

      test('returns none when installed version matches neither', () {
        final state = AppState(
          mods: {stableV090},
          releases: {
            rel(43, '1.0.0'),
            rel(44, '1.1.0', isPlaytest: true),
          },
        );

        expect(
          selectCurrentModReleaseType(state, stableV090),
          ModReleaseType.none,
        );
      });
    });

    group('selectAvailableReleaseUpdates / selectAvailablePlaytestUpdates', () {
      test('exclude versions installed by any copy of the mod', () {
        final state = AppState(
          mods: {stableV100, playtestV110},
          releases: {
            rel(10, '1.0.0'),
            rel(20, '1.1.0', isPlaytest: true),
          },
        );

        expect(selectAvailableReleaseUpdates(state), isEmpty);
        expect(selectAvailablePlaytestUpdates(state), isEmpty);
      });

      test('keep versions that are not installed', () {
        final state = AppState(
          mods: {stableV100},
          releases: {
            rel(10, '1.0.0'),
            rel(20, '1.1.0', isPlaytest: true),
          },
        );

        expect(selectAvailableReleaseUpdates(state), isEmpty);
        final availablePlaytests = selectAvailablePlaytestUpdates(state);
        expect(availablePlaytests, hasLength(1));
        expect(availablePlaytests.first.version, '1.1.0');
      });
    });

    group('selectUpdatesCount', () {
      test('counts outstanding updates only, excluding installed versions',
          () {
        final state = AppState(
          mods: {stableV100},
          releases: {
            rel(10, '1.0.0'),
            rel(20, '1.1.0', isPlaytest: true),
          },
        );

        expect(selectUpdatesCount(state), 1);
      });

      test('returns zero when everything is up to date', () {
        final state = AppState(
          mods: {stableV100, playtestV110},
          releases: {
            rel(10, '1.0.0'),
            rel(20, '1.1.0', isPlaytest: true),
          },
        );

        expect(selectUpdatesCount(state), 0);
      });

      test('excludes updates for hidden mods', () {
        final hiddenMod = mod('2.0.0', id: 'other');

        final state = AppState(
          mods: {stableV100, hiddenMod},
          hiddenMods: {hiddenMod.key},
          releases: {
            rel(20, '1.1.0', isPlaytest: true),
            rel(30, '3.0.0', modId: 'other'),
          },
        );

        expect(selectUpdatesCount(state), 1);
      });

      test('counts all available updates when showHiddenMods is true', () {
        final hiddenMod = mod('2.0.0', id: 'other');

        final state = AppState(
          mods: {stableV100, hiddenMod},
          hiddenMods: {hiddenMod.key},
          showHiddenMods: true,
          releases: {
            rel(20, '1.1.0', isPlaytest: true),
            rel(30, '3.0.0', modId: 'other'),
          },
        );

        expect(selectUpdatesCount(state), 2);
      });

      test('returns zero when all available updates are for hidden mods', () {
        final hiddenMod = mod('2.0.0', id: 'other');

        final state = AppState(
          mods: {hiddenMod},
          hiddenMods: {hiddenMod.key},
          releases: {rel(30, '3.0.0', modId: 'other')},
        );

        expect(selectUpdatesCount(state), 0);
      });
    });
  });
}
