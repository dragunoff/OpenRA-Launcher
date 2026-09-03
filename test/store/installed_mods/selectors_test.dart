import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/selectors.dart';

void main() {
  group('Installed mods selectors', () {
    final regularMod = Mod(
      key: 'regular-1.0.0',
      id: 'regular',
      version: '1.0.0',
      title: 'Regular Mod',
      launchPath: '/launch',
      launchArgs: const [''],
    );

    final favoriteMod = Mod(
      key: 'favorite-1.0.0',
      id: 'favorite',
      version: '1.0.0',
      title: 'Favorite Mod',
      launchPath: '/launch',
      launchArgs: const [''],
    );

    final hiddenMod = Mod(
      key: 'hidden-1.0.0',
      id: 'hidden',
      version: '1.0.0',
      title: 'Hidden Mod',
      launchPath: '/launch',
      launchArgs: const [''],
    );

    final devMod = Mod(
      key: 'dev-mod-{DEV_VERSION}',
      id: 'dev-mod',
      version: '{DEV_VERSION}',
      title: 'Dev Mod',
      launchPath: '/launch',
      launchArgs: const [''],
    );

    final hiddenFavoriteMod = Mod(
      key: 'hidden-fav-1.0.0',
      id: 'hidden-fav',
      version: '1.0.0',
      title: 'Hidden Favorite Mod',
      launchPath: '/launch',
      launchArgs: const [''],
    );

    group('selectInstalledMods', () {
      test('should return all non-favorite, non-dev mods', () {
        final state = AppState(
          mods: {regularMod, favoriteMod, devMod},
          favoriteMods: {favoriteMod.key},
        );

        final result = selectInstalledMods(state);

        expect(result, {regularMod});
      });

      test('should include hidden mods that are not favorited or dev', () {
        final state = AppState(
          mods: {regularMod, hiddenMod},
          hiddenMods: {hiddenMod.key},
        );

        final result = selectInstalledMods(state);

        expect(result, {regularMod, hiddenMod});
      });

      test('should return all mods when none are favorited', () {
        final state = AppState(mods: {regularMod});

        final result = selectInstalledMods(state);

        expect(result, {regularMod});
      });
    });

    group('selectFavoriteMods', () {
      test('should return only favorited mods', () {
        final state = AppState(
          mods: {regularMod, favoriteMod},
          favoriteMods: {favoriteMod.key},
        );

        final result = selectFavoriteMods(state);

        expect(result, {favoriteMod});
      });

      test('should include hidden mods if they are also favorited', () {
        final state = AppState(
          mods: {hiddenFavoriteMod},
          favoriteMods: {hiddenFavoriteMod.key},
          hiddenMods: {hiddenFavoriteMod.key},
        );

        final result = selectFavoriteMods(state);

        expect(result, {hiddenFavoriteMod});
      });

      test('should return empty set when no mods are favorited', () {
        final state = AppState(mods: {regularMod});

        final result = selectFavoriteMods(state);

        expect(result, isEmpty);
      });
    });

    group('selectDevMods', () {
      test('should return only dev mods', () {
        final state = AppState(mods: {regularMod, devMod});

        final result = selectDevMods(state);

        expect(result, {devMod});
      });

      test('should include hidden dev mods', () {
        final state = AppState(mods: {devMod}, hiddenMods: {devMod.key});

        final result = selectDevMods(state);

        expect(result, {devMod});
      });

      test('should exclude favorited dev mods', () {
        final state = AppState(mods: {devMod}, favoriteMods: {devMod.key});

        final result = selectDevMods(state);

        expect(result, isEmpty);
      });
    });

    group('selectHiddenMods', () {
      test('should return only hidden mods', () {
        final state = AppState(
          mods: {regularMod, hiddenMod},
          hiddenMods: {hiddenMod.key},
        );

        final result = selectHiddenMods(state);

        expect(result, {hiddenMod});
      });

      test('should return hidden mods even if they are also favorites', () {
        final state = AppState(
          mods: {hiddenFavoriteMod},
          favoriteMods: {hiddenFavoriteMod.key},
          hiddenMods: {hiddenFavoriteMod.key},
        );

        final result = selectHiddenMods(state);

        expect(result, {hiddenFavoriteMod});
      });

      test('should return empty set when no mods are hidden', () {
        final state = AppState(mods: {regularMod});

        final result = selectHiddenMods(state);

        expect(result, isEmpty);
      });
    });
  });
}
