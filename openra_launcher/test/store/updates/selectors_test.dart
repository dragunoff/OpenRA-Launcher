import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/updates/selectors.dart';

void main() {
  group('Update selectors', () {
    final installedMod = Mod(
      key: 'test-1.0.0',
      id: 'test',
      version: '1.0.0',
      title: 'Test Mod',
      launchPath: '/launch',
      launchArgs: const [''],
    );

    final installedPlaytest = Mod(
      key: 'test-1.1.0-playtest',
      id: 'test',
      version: '1.1.0',
      title: 'Test Mod',
      launchPath: '/launch',
      launchArgs: const [''],
    );

    test('selectLatestReleaseForMod returns the latest non-playtest release',
        () {
      final state = AppState(
        mods: {installedMod},
        releases: {
          Release(
            modId: 'test',
            id: 10,
            name: 'Release 1.0.1',
            version: '1.0.1',
            isPlaytest: false,
            htmlUrl: 'https://example.com/1.0.1',
          ),
          Release(
            modId: 'test',
            id: 12,
            name: 'Release 1.0.2',
            version: '1.0.2',
            isPlaytest: false,
            htmlUrl: 'https://example.com/1.0.2',
          ),
        },
      );

      final latest = selectLatestReleaseForMod(state, 'test');

      expect(latest, isNotNull);
      expect(latest!.version, '1.0.2');
    });

    test('selectLatestPlaytestForMod returns the latest playtest release', () {
      final state = AppState(
        mods: {installedMod},
        releases: {
          Release(
            modId: 'test',
            id: 20,
            name: 'Playtest 1.1.0',
            version: '1.1.0',
            isPlaytest: true,
            htmlUrl: 'https://example.com/1.1.0',
          ),
          Release(
            modId: 'test',
            id: 21,
            name: 'Playtest 1.2.0',
            version: '1.2.0',
            isPlaytest: true,
            htmlUrl: 'https://example.com/1.2.0',
          ),
        },
      );

      final latest = selectLatestPlaytestForMod(state, 'test');

      expect(latest, isNotNull);
      expect(latest!.version, '1.2.0');
    });

    test('selectHasReleaseUpdate returns true when a newer release exists', () {
      final state = AppState(
        mods: {installedMod},
        releases: {
          Release(
            modId: 'test',
            id: 11,
            name: 'Release 1.1.0',
            version: '1.1.0',
            isPlaytest: false,
            htmlUrl: 'https://example.com/1.1.0',
          ),
        },
      );

      expect(selectHasReleaseUpdate(state, installedMod), isTrue);
    });

    test(
        'selectHasReleaseUpdate returns false when installed version is latest release',
        () {
      final state = AppState(
        mods: {installedMod},
        releases: {
          Release(
            modId: 'test',
            id: 11,
            name: 'Release 1.0.0',
            version: '1.0.0',
            isPlaytest: false,
            htmlUrl: 'https://example.com/1.0.0',
          ),
        },
      );

      expect(selectHasReleaseUpdate(state, installedMod), isFalse);
    });

    test(
        'selectHasPlaytestUpdate returns true when a playtest update exists and is not installed',
        () {
      final state = AppState(
        mods: {installedMod},
        releases: {
          Release(
            modId: 'test',
            id: 30,
            name: 'Playtest 1.1.0',
            version: '1.1.0',
            isPlaytest: true,
            htmlUrl: 'https://example.com/1.1.0',
          ),
        },
      );

      expect(selectHasPlaytestUpdate(state, installedMod), isTrue);
    });

    test(
        'selectHasPlaytestUpdate returns false when the latest playtest is installed',
        () {
      final state = AppState(
        mods: {installedPlaytest},
        releases: {
          Release(
            modId: 'test',
            id: 31,
            name: 'Playtest 1.1.0',
            version: '1.1.0',
            isPlaytest: true,
            htmlUrl: 'https://example.com/1.1.0',
          ),
        },
      );

      expect(selectHasPlaytestUpdate(state, installedPlaytest), isFalse);
    });

    test(
        'selectCurrentModReleaseType returns release when installed version matches latest release',
        () {
      final state = AppState(
        mods: {installedMod},
        releases: {
          Release(
            modId: 'test',
            id: 41,
            name: 'Release 1.0.0',
            version: '1.0.0',
            isPlaytest: false,
            htmlUrl: 'https://example.com/1.0.0',
          ),
        },
      );

      expect(selectCurrentModReleaseType(state, installedMod),
          ModReleaseType.release);
    });

    test(
        'selectCurrentModReleaseType returns playtest when installed version matches latest playtest',
        () {
      final state = AppState(
        mods: {installedPlaytest},
        releases: {
          Release(
            modId: 'test',
            id: 42,
            name: 'Playtest 1.1.0',
            version: '1.1.0',
            isPlaytest: true,
            htmlUrl: 'https://example.com/1.1.0',
          ),
        },
      );

      expect(selectCurrentModReleaseType(state, installedPlaytest),
          ModReleaseType.playtest);
    });

    test(
        'selectCurrentModReleaseType returns none when installed version does not match any latest update',
        () {
      final state = AppState(
        mods: {installedMod},
        releases: {
          Release(
            modId: 'test',
            id: 43,
            name: 'Release 1.1.0',
            version: '1.1.0',
            isPlaytest: false,
            htmlUrl: 'https://example.com/1.1.0',
          ),
          Release(
            modId: 'test',
            id: 44,
            name: 'Playtest 1.2.0',
            version: '1.2.0',
            isPlaytest: true,
            htmlUrl: 'https://example.com/1.2.0',
          ),
        },
      );

      expect(selectCurrentModReleaseType(state, installedMod),
          ModReleaseType.none);
    });

    group('selectUpdatesCount', () {
      test('should count all releases when no mods are hidden', () {
        final state = AppState(
          mods: {installedMod},
          releases: {
            Release(
              modId: 'test',
              id: 10,
              name: 'Release 1.0.1',
              version: '1.0.1',
              isPlaytest: false,
              htmlUrl: 'https://example.com/1.0.1',
            ),
            Release(
              modId: 'test',
              id: 20,
              name: 'Playtest 1.1.0',
              version: '1.1.0',
              isPlaytest: true,
              htmlUrl: 'https://example.com/1.1.0',
            ),
          },
        );

        expect(selectUpdatesCount(state), 2);
      });

      test('should exclude releases for hidden mods', () {
        final hiddenMod = Mod(
          key: 'other-2.0.0',
          id: 'other',
          version: '2.0.0',
          title: 'Other Mod',
          launchPath: '/launch',
          launchArgs: const [''],
        );

        final state = AppState(
          mods: {installedMod, hiddenMod},
          hiddenMods: {hiddenMod.key},
          releases: {
            Release(
              modId: 'test',
              id: 10,
              name: 'Release 1.0.1',
              version: '1.0.1',
              isPlaytest: false,
              htmlUrl: 'https://example.com/1.0.1',
            ),
            Release(
              modId: 'other',
              id: 20,
              name: 'Release 3.0.0',
              version: '3.0.0',
              isPlaytest: false,
              htmlUrl: 'https://example.com/3.0.0',
            ),
          },
        );

        expect(selectUpdatesCount(state), 1);
      });

      test('should count all releases when showHiddenMods is true', () {
        final hiddenMod = Mod(
          key: 'other-2.0.0',
          id: 'other',
          version: '2.0.0',
          title: 'Other Mod',
          launchPath: '/launch',
          launchArgs: const [''],
        );

        final state = AppState(
          mods: {installedMod, hiddenMod},
          hiddenMods: {hiddenMod.key},
          showHiddenMods: true,
          releases: {
            Release(
              modId: 'test',
              id: 10,
              name: 'Release 1.0.1',
              version: '1.0.1',
              isPlaytest: false,
              htmlUrl: 'https://example.com/1.0.1',
            ),
            Release(
              modId: 'other',
              id: 20,
              name: 'Release 3.0.0',
              version: '3.0.0',
              isPlaytest: false,
              htmlUrl: 'https://example.com/3.0.0',
            ),
          },
        );

        expect(selectUpdatesCount(state), 2);
      });

      test('should return zero when all releases are for hidden mods', () {
        final hiddenMod = Mod(
          key: 'other-2.0.0',
          id: 'other',
          version: '2.0.0',
          title: 'Other Mod',
          launchPath: '/launch',
          launchArgs: const [''],
        );

        final state = AppState(
          mods: {hiddenMod},
          hiddenMods: {hiddenMod.key},
          releases: {
            Release(
              modId: 'other',
              id: 20,
              name: 'Release 3.0.0',
              version: '3.0.0',
              isPlaytest: false,
              htmlUrl: 'https://example.com/3.0.0',
            ),
          },
        );

        expect(selectUpdatesCount(state), 0);
      });
    });
  });
}
