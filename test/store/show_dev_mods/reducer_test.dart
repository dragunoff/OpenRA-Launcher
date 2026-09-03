import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/store/show_dev_mods/actions.dart';
import 'package:openra_launcher/store/show_dev_mods/reducer.dart';

void main() {
  group('Show dev mods reducer', () {
    test('should set to true on ShowDevModsOn', () {
      final nextState = showDevModsReducer(false, ShowDevModsOn());
      expect(nextState, isTrue);
    });

    test('should set to false on ShowDevModsOff', () {
      final nextState = showDevModsReducer(true, ShowDevModsOff());
      expect(nextState, isFalse);
    });

    test('should be idempotent when already on', () {
      final nextState = showDevModsReducer(true, ShowDevModsOn());
      expect(nextState, isTrue);
    });

    test('should be idempotent when already off', () {
      final nextState = showDevModsReducer(false, ShowDevModsOff());
      expect(nextState, isFalse);
    });
  });
}
