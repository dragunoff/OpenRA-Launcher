import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/store/hidden_mods/actions.dart';
import 'package:openra_launcher/store/hidden_mods/reducer.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';

void main() {
  group('Hidden mods reducer', () {
    final hiddenKey = 'hidden-mod-1.0.0';
    final missingHiddenKey = 'missing-mod-1.0.0';

    final installedMod = Mod(
      key: hiddenKey,
      id: 'hidden-mod',
      version: '1.0.0',
      title: 'Hidden Mod',
      launchPath: '/launch',
      launchArgs: const [''],
    );

    group('HideModAction', () {
      test('should add mod key to hidden mods', () {
        final state = <String>{};
        final action = HideModAction(installedMod);

        final nextState = hiddenModsReducer(state, action);

        expect(nextState, {hiddenKey});
      });

      test('should not duplicate existing hidden mod', () {
        final state = {hiddenKey};
        final action = HideModAction(installedMod);

        final nextState = hiddenModsReducer(state, action);

        expect(nextState, {hiddenKey});
      });
    });

    group('UnhideModAction', () {
      test('should remove mod key from hidden mods', () {
        final state = {hiddenKey};
        final action = UnhideModAction(installedMod);

        final nextState = hiddenModsReducer(state, action);

        expect(nextState, isEmpty);
      });

      test('should handle removing a mod that is not hidden', () {
        final state = <String>{};
        final action = UnhideModAction(installedMod);

        final nextState = hiddenModsReducer(state, action);

        expect(nextState, isEmpty);
      });
    });

    group('ModsLoadedAction', () {
      test('should retain hidden mods when loaded mods still include them', () {
        final state = {hiddenKey};
        final action = ModsLoadedAction({installedMod});

        final nextState = hiddenModsReducer(state, action);

        expect(nextState, {hiddenKey});
      });

      test(
          'should remove hidden mods that are no longer available after mods load',
          () {
        final state = {hiddenKey, missingHiddenKey};
        final action = ModsLoadedAction({installedMod});

        final nextState = hiddenModsReducer(state, action);

        expect(nextState, {hiddenKey});
      });

      test('should clear all hidden mods when loaded mods are empty', () {
        final state = {hiddenKey};
        final action = ModsLoadedAction({});

        final nextState = hiddenModsReducer(state, action);

        expect(nextState, isEmpty);
      });
    });

    group('ModsEmptyAction', () {
      test('should clear hidden mods when installed mods are empty', () {
        final state = {hiddenKey};
        final action = ModsEmptyAction();

        final nextState = hiddenModsReducer(state, action);

        expect(nextState, isEmpty);
      });
    });

    test('should return unmodifiable set', () {
      final state = <String>{};
      final action = HideModAction(installedMod);

      final nextState = hiddenModsReducer(state, action);

      expect(() => nextState.add('new-key'), throwsUnsupportedError);
    });
  });
}
