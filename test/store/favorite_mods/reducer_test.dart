import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/store/favorite_mods/reducer.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';

void main() {
  group('Favorite mods reducer', () {
    final favoriteKey = 'favorite-mod-1.0.0';
    final missingFavoriteKey = 'missing-mod-1.0.0';

    final installedMod = Mod(
      key: favoriteKey,
      id: 'favorite-mod',
      version: '1.0.0',
      title: 'Favorite Mod',
      launchPath: '/launch',
      launchArgs: const [''],
    );

    test('should retain favorite mods when loaded mods still include them', () {
      final state = {favoriteKey};
      final action = ModsLoadedAction({installedMod});

      final nextState = favoriteModsReducer(state, action);

      expect(nextState, {favoriteKey});
    });

    test(
      'should remove favorites that are no longer available after mods load',
      () {
        final state = {favoriteKey, missingFavoriteKey};
        final action = ModsLoadedAction({installedMod});

        final nextState = favoriteModsReducer(state, action);

        expect(nextState, {favoriteKey});
      },
    );

    test('should clear favorites when installed mods are empty', () {
      final state = {favoriteKey};
      final action = ModsEmptyAction();

      final nextState = favoriteModsReducer(state, action);

      expect(nextState, isEmpty);
    });
  });
}
