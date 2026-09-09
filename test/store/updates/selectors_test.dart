import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database_info.dart';
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
    }) => Release(
      modId: modId,
      id: id,
      name: '${isPlaytest ? 'Playtest' : 'Release'} $version',
      version: version,
      isPlaytest: isPlaytest,
      htmlUrl: 'https://example.com/$version',
    );

    ModDatabase db(Set<Release> releases) {
      final byModId = <String, ModDatabaseInfo>{};

      for (final release in releases) {
        final existing =
            byModId[release.modId] ??
            ModDatabaseInfo(modId: release.modId, title: '');
        byModId[release.modId] = release.isPlaytest
            ? ModDatabaseInfo(
                modId: release.modId,
                title: existing.title,
                stable: existing.stable,
                playtest: release,
              )
            : ModDatabaseInfo(
                modId: release.modId,
                title: existing.title,
                stable: release,
                playtest: existing.playtest,
              );
      }

      return ModDatabase(mods: byModId);
    }

    final stableV100 = mod('1.0.0');
    final stableV090 = mod('0.9.0');
    final playtestV110 = mod('1.1.0');

    group('selectLatestReleaseForMod', () {
      test('returns the latest non-playtest release by id', () {
        final state = AppState(
          mods: {stableV100},
          modDatabase: db({
            rel(10, '1.0.1'),
            rel(12, '1.0.2'),
            rel(11, '1.1.0', isPlaytest: true),
          }),
        );

        expect(selectLatestReleaseForMod(state, 'test')!.version, '1.0.2');
      });

      test('returns null when no release exists for the mod', () {
        final state = AppState(
          mods: {stableV100},
          modDatabase: db({rel(10, '1.0.1', modId: 'other')}),
        );

        expect(selectLatestReleaseForMod(state, 'test'), isNull);
      });
    });

    group('selectLatestPlaytestForMod', () {
      test('returns the latest playtest release by id', () {
        final state = AppState(
          mods: {stableV100},
          modDatabase: db({
            rel(20, '1.1.0', isPlaytest: true),
            rel(21, '1.2.0', isPlaytest: true),
            rel(22, '1.3.0'),
          }),
        );

        expect(selectLatestPlaytestForMod(state, 'test')!.version, '1.2.0');
      });

      test('returns null when no playtest exists for the mod', () {
        final state = AppState(mods: {stableV100}, modDatabase: db({}));

        expect(selectLatestPlaytestForMod(state, 'test'), isNull);
      });
    });

    group('selectCurrentModReleaseType', () {
      test('returns release when installed version matches latest release', () {
        final state = AppState(
          mods: {stableV100},
          modDatabase: db({rel(41, '1.0.0')}),
        );

        expect(
          selectCurrentModReleaseType(state, stableV100),
          ModReleaseType.release,
        );
      });

      test(
        'returns playtest when installed version matches latest playtest',
        () {
          final state = AppState(
            mods: {playtestV110},
            modDatabase: db({rel(42, '1.1.0', isPlaytest: true)}),
          );

          expect(
            selectCurrentModReleaseType(state, playtestV110),
            ModReleaseType.playtest,
          );
        },
      );

      test('takes precedence of release over playtest on equal versions', () {
        final state = AppState(
          mods: {mod('1.0.0')},
          modDatabase: db({
            rel(43, '1.0.0'),
            rel(44, '1.0.0', isPlaytest: true),
          }),
        );

        expect(
          selectCurrentModReleaseType(state, mod('1.0.0')),
          ModReleaseType.release,
        );
      });

      test('returns none when installed version matches neither', () {
        final state = AppState(
          mods: {stableV090},
          modDatabase: db({
            rel(43, '1.0.0'),
            rel(44, '1.1.0', isPlaytest: true),
          }),
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
          modDatabase: db({
            rel(10, '1.0.0'),
            rel(20, '1.1.0', isPlaytest: true),
          }),
        );

        expect(selectAvailableReleaseUpdates(state), isEmpty);
        expect(selectAvailablePlaytestUpdates(state), isEmpty);
      });

      test('keep versions that are not installed', () {
        final state = AppState(
          mods: {stableV100},
          modDatabase: db({
            rel(10, '1.0.0'),
            rel(20, '1.1.0', isPlaytest: true),
          }),
        );

        expect(selectAvailableReleaseUpdates(state), isEmpty);
        final availablePlaytests = selectAvailablePlaytestUpdates(state);
        expect(availablePlaytests, hasLength(1));
        expect(availablePlaytests.first.version, '1.1.0');
      });

      test('exclude releases for mods that are not installed', () {
        final state = AppState(
          mods: {stableV100},
          modDatabase: db({rel(10, '1.0.0'), rel(20, '1.1.0', modId: 'other')}),
        );

        expect(selectAvailableReleaseUpdates(state), isEmpty);
        expect(selectAvailablePlaytestUpdates(state), isEmpty);
      });
    });

    group('selectIsModSupported', () {
      test('returns true when a release exists for the mod', () {
        final state = AppState(
          mods: {stableV100},
          modDatabase: db({rel(10, '1.0.0')}),
        );

        expect(selectIsModSupported(state, 'test'), isTrue);
      });

      test('returns true when only a playtest exists for the mod', () {
        final state = AppState(
          mods: {stableV100},
          modDatabase: db({rel(20, '1.1.0', isPlaytest: true)}),
        );

        expect(selectIsModSupported(state, 'test'), isTrue);
      });

      test('returns false when the mod has no release in the database', () {
        final state = AppState(
          mods: {stableV100},
          modDatabase: db({rel(10, '1.0.0', modId: 'other')}),
        );

        expect(selectIsModSupported(state, 'test'), isFalse);
      });

      test('returns false when the database is empty', () {
        final state = AppState(mods: {stableV100}, modDatabase: db({}));

        expect(selectIsModSupported(state, 'test'), isFalse);
      });
    });

    group('selectUpdatesCount', () {
      test('counts outstanding updates only, excluding installed versions', () {
        final state = AppState(
          mods: {stableV100},
          modDatabase: db({
            rel(10, '1.0.0'),
            rel(20, '1.1.0', isPlaytest: true),
          }),
        );

        expect(selectUpdatesCount(state), 1);
      });

      test('returns zero when everything is up to date', () {
        final state = AppState(
          mods: {stableV100, playtestV110},
          modDatabase: db({
            rel(10, '1.0.0'),
            rel(20, '1.1.0', isPlaytest: true),
          }),
        );

        expect(selectUpdatesCount(state), 0);
      });

      test('excludes updates for hidden mods', () {
        final hiddenMod = mod('2.0.0', id: 'other');

        final state = AppState(
          mods: {stableV100, hiddenMod},
          hiddenMods: {hiddenMod.key},
          modDatabase: db({
            rel(20, '1.1.0', isPlaytest: true),
            rel(30, '3.0.0', modId: 'other'),
          }),
        );

        expect(selectUpdatesCount(state), 1);
      });

      test(
        'excludes updates for hidden mods even when showHiddenMods is true',
        () {
          final hiddenMod = mod('2.0.0', id: 'other');

          final state = AppState(
            mods: {stableV100, hiddenMod},
            hiddenMods: {hiddenMod.key},
            showHiddenMods: true,
            modDatabase: db({
              rel(20, '1.1.0', isPlaytest: true),
              rel(30, '3.0.0', modId: 'other'),
            }),
          );

          expect(selectUpdatesCount(state), 1);
        },
      );

      test('returns zero when all available updates are for hidden mods', () {
        final hiddenMod = mod('2.0.0', id: 'other');

        final state = AppState(
          mods: {hiddenMod},
          hiddenMods: {hiddenMod.key},
          modDatabase: db({rel(30, '3.0.0', modId: 'other')}),
        );

        expect(selectUpdatesCount(state), 0);
      });
    });
  });
}
