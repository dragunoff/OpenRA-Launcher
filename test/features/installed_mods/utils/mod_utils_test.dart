import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/constants/mod_constants.dart';
import 'package:openra_launcher/features/installed_mods/utils/mod_utils.dart';

import '../../../../testing/utils/test_utils.dart';

void main() {
  group('Dev mod check', () {
    test('should return true if mod has the dev version string', () {
      final mod =
          TestUtils.generateMod().copyWith(version: ModConstants.devModVersion);

      expect(ModUtils.isDevMod(mod), true);
    });

    test('should return false if mod does not have dev version string', () {
      final mod = TestUtils.generateMod();

      expect(ModUtils.isDevMod(mod), false);
    });
  });
}
