import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/constants/constants.dart';
import 'package:openra_launcher/utils/mod_utils.dart';

import '../../utils/test_utils.dart';

void main() {
  group('Dev mod check', () {
    test('should return true if mod has the dev version string', () {
      var mod =
          TestUtils.generateMod().copyWith(version: Constants.devModVersion);

      expect(ModUtils.isDevMod(mod), true);
    });

    test('should return false if mod does not have dev version string', () {
      var mod = TestUtils.generateMod();

      expect(ModUtils.isDevMod(mod), false);
    });
  });

  group('Official mod check', () {
    test('should return true if mod is an official one', () {
      var mod = TestUtils.generateRandomOfficialMod();

      expect(ModUtils.isOfficialMod(mod), true);
    });

    test('should return false if mod is not an official one', () {
      var mod = TestUtils.generateMod();

      expect(ModUtils.isOfficialMod(mod), false);
    });
  });
}
