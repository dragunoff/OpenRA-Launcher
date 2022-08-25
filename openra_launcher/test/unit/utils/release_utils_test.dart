import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/constants/constants.dart';
import 'package:openra_launcher/utils/release_utils.dart';

void main() {
  group('Supported for release', () {
    test('should return all mods that are supported', () {
      final supported = Constants.modRepos.keys.toSet();
      if (supported.contains('openra')) {
        supported
          ..remove('openra')
          ..addAll(Constants.officialModIds);
      }

      expect(ReleaseUtils.getSupportedMods(), supported);
    });
  });
}
