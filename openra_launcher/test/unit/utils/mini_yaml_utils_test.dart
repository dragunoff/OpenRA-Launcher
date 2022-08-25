import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/core/error/exceptions.dart';
import 'package:openra_launcher/utils/mini_yaml_utils.dart';

import '../../utils/test_utils.dart';

void main() {
  group('MiniYaml utilities', () {
    test('should parse valid files', () {
      final mandatoryFields = [
        'Id',
        'Version',
        'Title',
        'LaunchPath',
        'LaunchArgs'
      ];
      final metadata = MiniYamlUtils.modMetadataFromFile(
          TestUtils.getYamlFile('valid.yaml'));

      expect(metadata.keys, containsAll(mandatoryFields));
      expect(metadata['Id'], 'ra');
      expect(metadata['Version'], 'release-20210321');
      expect(metadata['Title'], 'Red Alert');
      expect(metadata['LaunchPath'],
          '/home/user/OpenRA/OpenRA-Red-Alert-x86_64.AppImage');
      expect(metadata['LaunchArgs'], 'Game.Mod=ra');
    });

    test('should parse valid files without icons', () {
      final mandatoryFields = [
        'Id',
        'Version',
        'Title',
        'LaunchPath',
        'LaunchArgs'
      ];
      final metadata = MiniYamlUtils.modMetadataFromFile(
          TestUtils.getYamlFile('valid-no-icons.yaml'));

      expect(metadata.keys, containsAll(mandatoryFields));
      expect(metadata['Id'], 'ra');
      expect(metadata['Version'], 'release-20210321');
      expect(metadata['Title'], 'Red Alert');
      expect(metadata['LaunchPath'],
          '/home/user/OpenRA/OpenRA-Red-Alert-x86_64.AppImage');
      expect(metadata['LaunchArgs'], 'Game.Mod=ra');
    });

    test('should parse valid files with icons', () {
      final metadata = MiniYamlUtils.modMetadataFromFile(
          TestUtils.getYamlFile('valid.yaml'));
      final base64Png = TestUtils.getTestPngBase64();

      expect(metadata['Icon'], base64Png);
      expect(metadata['Icon2x'], base64Png);
      expect(metadata['Icon3x'], base64Png);
    });

    test('should throw if "Id" field is missing', () {
      expect(
          () => MiniYamlUtils.modMetadataFromFile(
              TestUtils.getYamlFile('no-id.yaml')),
          throwsA(isA<MiniYamlFormatException>()));
    });

    test('should throw if "Version" field is missing', () {
      expect(
          () => MiniYamlUtils.modMetadataFromFile(
              TestUtils.getYamlFile('no-version.yaml')),
          throwsA(isA<MiniYamlFormatException>()));
    });

    test('should throw if "Title" field is missing', () {
      expect(
          () => MiniYamlUtils.modMetadataFromFile(
              TestUtils.getYamlFile('no-title.yaml')),
          throwsA(isA<MiniYamlFormatException>()));
    });

    test('should throw if "LaunchPath" field is missing', () {
      expect(
          () => MiniYamlUtils.modMetadataFromFile(
              TestUtils.getYamlFile('no-launch-path.yaml')),
          throwsA(isA<MiniYamlFormatException>()));
    });

    test('should throw if "LaunchArgs" field is missing', () {
      expect(
          () => MiniYamlUtils.modMetadataFromFile(
              TestUtils.getYamlFile('no-launch-args.yaml')),
          throwsA(isA<MiniYamlFormatException>()));
    });

    test('should throw if "Id" field is empty', () {
      expect(
          () => MiniYamlUtils.modMetadataFromFile(
              TestUtils.getYamlFile('empty-id.yaml')),
          throwsA(isA<MiniYamlFormatException>()));
    });

    test('should throw if "Version" field is empty', () {
      expect(
          () => MiniYamlUtils.modMetadataFromFile(
              TestUtils.getYamlFile('empty-version.yaml')),
          throwsA(isA<MiniYamlFormatException>()));
    });

    test('should throw if "Title" field is empty', () {
      expect(
          () => MiniYamlUtils.modMetadataFromFile(
              TestUtils.getYamlFile('empty-title.yaml')),
          throwsA(isA<MiniYamlFormatException>()));
    });

    test('should throw if "LaunchPath" field is empty', () {
      expect(
          () => MiniYamlUtils.modMetadataFromFile(
              TestUtils.getYamlFile('empty-launch-path.yaml')),
          throwsA(isA<MiniYamlFormatException>()));
    });

    test('should throw if "LaunchArgs" field is empty', () {
      expect(
          () => MiniYamlUtils.modMetadataFromFile(
              TestUtils.getYamlFile('empty-launch-args.yaml')),
          throwsA(isA<MiniYamlFormatException>()));
    });

    test('should throw if "LaunchPath" points to a DLL', () {
      expect(
          () => MiniYamlUtils.modMetadataFromFile(
              TestUtils.getYamlFile('invalid-dll-launch-path.yaml')),
          throwsA(isA<MiniYamlFormatException>()));
    });
  });
}
