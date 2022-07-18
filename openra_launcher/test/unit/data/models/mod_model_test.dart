import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/data/models/mod_model.dart';
import 'package:openra_launcher/domain/entities/mod.dart';

import '../../../utils/test_utils.dart';

void main() {
  const testObj = ModModel(
    key: 'test-version',
    id: 'test',
    version: 'version',
    title: 'Test Mod',
    launchPath: '',
    launchArgs: [''],
  );

  group('Mod model', () {
    test(
      'should be a subclass of Mod entity',
      () async {
        expect(testObj, isA<Mod>());
      },
    );

    test('should construct object from MiniYaml file', () {
      final png = TestUtils.getTestPng();
      final mod = ModModel.fromFile(TestUtils.getYamlFile('valid.yaml'));

      expect(mod.key, 'ra-release-20210321');
      expect(mod.id, 'ra');
      expect(mod.version, 'release-20210321');
      expect(mod.title, 'Red Alert');
      expect(
          mod.launchPath, '/home/user/OpenRA/OpenRA-Red-Alert-x86_64.AppImage');
      expect(mod.launchArgs, ['Game.Mod=ra']);
      expect(mod.icon, png);
      expect(mod.icon2x, png);
      expect(mod.icon3x, png);
      expect(mod.isRelease, false);
      expect(mod.isPlaytest, false);
      expect(mod.hasRelease, false);
      expect(mod.hasPlaytest, false);
    });
  });
}
