import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/domain/entities/mod.dart';

void main() {
  const testObj = Mod(
    key: 'test-version',
    id: 'test',
    version: 'version',
    title: 'Test Mod',
    launchPath: '/launchPath',
    launchArgs: [''],
  );

  group('Mod entity', () {
    group('copyWith', () {
      test('should copy object with all fields', () {
        final mod = testObj.copyWith(
          key: 'test1-version1',
          id: 'test1',
          version: 'version1',
          title: 'title1',
          launchPath: '/launchPath1',
          launchArgs: const ['launchArgs1'],
          icon: Uint8List.fromList([0]),
          icon2x: Uint8List.fromList([0, 1]),
          icon3x: Uint8List.fromList([0, 1, 2]),
          isRelease: true,
          isPlaytest: true,
          hasRelease: true,
          hasPlaytest: true,
        );

        expect(mod.key, 'test1-version1');
        expect(mod.id, 'test1');
        expect(mod.version, 'version1');
        expect(mod.title, 'title1');
        expect(mod.launchPath, '/launchPath1');
        expect(mod.launchArgs, ['launchArgs1']);
        expect(mod.icon, Uint8List.fromList([0]));
        expect(mod.icon2x, Uint8List.fromList([0, 1]));
        expect(mod.icon3x, Uint8List.fromList([0, 1, 2]));
        expect(mod.isRelease, true);
        expect(mod.isPlaytest, true);
        expect(mod.hasRelease, true);
        expect(mod.hasPlaytest, true);
      });
    });

    group('Identity', () {
      test('should tell if objects are identical', () {
        var a = testObj.copyWith();
        var b = testObj.copyWith();

        expect(a == b, true);
      });

      test('should tell if objects are not identical', () {
        var a = testObj.copyWith();
        var b = testObj.copyWith(id: 'testB');
        var c = testObj.copyWith(version: 'testC');
        var d = testObj.copyWith(title: 'testD');
        var e = testObj.copyWith(launchPath: 'testE');

        expect(a == b, false);
        expect(a == c, false);
        expect(a == d, false);
        expect(a == e, false);
      });
    });

    group('Comparable', () {
      test('should sort objects by title ASC', () {
        var a = testObj.copyWith(title: 'A');
        var b = testObj.copyWith(title: 'B');
        var zero = testObj.copyWith(title: '0');

        var mods = [a, b, zero];

        mods.sort();

        expect(mods[0] == zero, true);
        expect(mods[1] == a, true);
        expect(mods[2] == b, true);
      });

      test('should sort objects by title ASC and then by version DESC', () {
        var a = testObj.copyWith(title: 'A', version: '1.0.0');
        var a2 = testObj.copyWith(title: 'A', version: '2.0.0');
        var zero = testObj.copyWith(title: '0');

        var mods = [a, a2, zero];

        mods.sort();

        expect(mods[0] == zero, true);
        expect(mods[1] == a2, true);
        expect(mods[2] == a, true);
      });
    });
  });
}
