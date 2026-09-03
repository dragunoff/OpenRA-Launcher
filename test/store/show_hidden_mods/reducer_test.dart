import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/store/show_hidden_mods/actions.dart';
import 'package:openra_launcher/store/show_hidden_mods/reducer.dart';

void main() {
  group('Show hidden mods reducer', () {
    test('should set to true on ShowHiddenModsOn', () {
      final nextState = showHiddenModsReducer(false, ShowHiddenModsOn());
      expect(nextState, isTrue);
    });

    test('should set to false on ShowHiddenModsOff', () {
      final nextState = showHiddenModsReducer(true, ShowHiddenModsOff());
      expect(nextState, isFalse);
    });

    test('should be idempotent when already on', () {
      final nextState = showHiddenModsReducer(true, ShowHiddenModsOn());
      expect(nextState, isTrue);
    });

    test('should be idempotent when already off', () {
      final nextState = showHiddenModsReducer(false, ShowHiddenModsOff());
      expect(nextState, isFalse);
    });
  });
}
