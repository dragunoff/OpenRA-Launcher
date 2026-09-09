import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/collapsed_mod_groups/actions.dart';
import 'package:openra_launcher/store/collapsed_mod_groups/reducer.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';

void main() {
  group('collapsedModGroupsReducer', () {
    test('collapses a group that is not collapsed yet', () {
      final state = <String>{};

      final next = collapsedModGroupsReducer(
        state,
        ToggleCollapsedModGroupAction('ra-release-20210321'),
      );

      expect(next, {'ra-release-20210321'});
    });

    test('expands a group that is already collapsed', () {
      final state = <String>{'ra-release-20210321'};

      final next = collapsedModGroupsReducer(
        state,
        ToggleCollapsedModGroupAction('ra-release-20210321'),
      );

      expect(next, isEmpty);
    });

    test('returns an unmodifiable set', () {
      final state = <String>{};

      final next = collapsedModGroupsReducer(
        state,
        ToggleCollapsedModGroupAction('ra-release-20210321'),
      );

      expect(
        () => next.add('d2k-release-20250330'),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('does not mutate the original state', () {
      final state = <String>{'ra-release-20210321'};

      collapsedModGroupsReducer(
        state,
        ToggleCollapsedModGroupAction('ra-release-20210321'),
      );

      expect(state, {'ra-release-20210321'});
    });

    test('prunes groups whose mod is no longer installed', () {
      final state = <String>{'ra-release-20210321', 'd2k-release-20250330'};
      final mods = {
        Mod(
          key: 'ra-release-20210321',
          id: 'ra',
          version: 'release-20210321',
          title: 'Red Alert',
          launchPath: '',
          launchArgs: [''],
        ),
      };

      final next = collapsedModGroupsReducer(state, ModsLoadedAction(mods));

      expect(next, {'ra-release-20210321'});
    });

    test('clears all collapsed groups when no mods are installed', () {
      final state = <String>{'ra-release-20210321'};

      final next = collapsedModGroupsReducer(state, ModsEmptyAction());

      expect(next, isEmpty);
    });
  });

  group('AppState collapsedModGroups serialization', () {
    test('toJson contains the current collapsed groups', () {
      final state = AppState(collapsedModGroups: {'ra-release-20210321'});

      final json = state.toJson();

      expect(json['collapsedModGroups'], ['ra-release-20210321']);
    });

    test('fromJson restores the saved collapsed groups', () {
      final json = {
        'collapsedModGroups': ['ra-release-20210321'],
      };

      final state = AppState.fromJson(json);

      expect(state!.collapsedModGroups, {'ra-release-20210321'});
    });

    test('fromJson defaults to an empty set when the key is absent', () {
      final state = AppState.fromJson({});

      expect(state!.collapsedModGroups, isEmpty);
    });

    test('fromJson defaults to an empty set when the key is null', () {
      final state = AppState.fromJson({'collapsedModGroups': null});

      expect(state!.collapsedModGroups, isEmpty);
    });
  });
}
