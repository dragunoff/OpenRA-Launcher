import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/tools/installed_mods_fixture_generator.dart';
import 'package:path/path.dart' as path;

void main() {
  group('InstalledModsFixtureGenerator', () {
    late Directory tempDir;

    setUp(() {
      tempDir =
          Directory.systemTemp.createTempSync('installed_mods_fixture_test');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('creates valid, dev and invalid fixture manifests', () async {
      final generator = InstalledModsFixtureGenerator();

      await generator.createFixtures(supportDirPath: tempDir.path);

      final metadataDir = Directory(path.join(tempDir.path, 'ModMetadata'));
      final launchTargetsDir =
          Directory(path.join(tempDir.path, 'LaunchTargets'));

      expect(metadataDir.existsSync(), isTrue);
      expect(
          File(path.join(metadataDir.path, 'ra-release-20210321.yaml'))
              .existsSync(),
          isTrue);
      expect(
          File(path.join(metadataDir.path, 'cnc-release-20210321.yaml'))
              .existsSync(),
          isTrue);
      expect(
          File(path.join(metadataDir.path, 'd2k-release-20210321.yaml'))
              .existsSync(),
          isTrue);
      expect(
          File(path.join(metadataDir.path, 'ts-{DEV_VERSION}.yaml'))
              .existsSync(),
          isTrue);
      expect(
          File(path.join(metadataDir.path, 'invalid-missing-launchpath.yaml'))
              .existsSync(),
          isTrue);
      expect(
          File(path.join(metadataDir.path, 'bogus-filename.yaml')).existsSync(),
          isTrue);
      expect(
          File(path.join(launchTargetsDir.path, 'ra-release-20210321.sh'))
              .existsSync(),
          isTrue);
      expect(
          File(path.join(launchTargetsDir.path, 'cnc-release-20210321.sh'))
              .existsSync(),
          isTrue);
      expect(
          File(path.join(launchTargetsDir.path, 'd2k-release-20210321.sh'))
              .existsSync(),
          isTrue);
      expect(
          File(path.join(launchTargetsDir.path, 'ts-{DEV_VERSION}.sh'))
              .existsSync(),
          isTrue);
      expect(File(path.join(launchTargetsDir.path, 'broken.sh')).existsSync(),
          isFalse);
    });

    test('cleans up generated manifest and launch target files', () async {
      final generator = InstalledModsFixtureGenerator();

      await generator.createFixtures(supportDirPath: tempDir.path);
      await generator.cleanupFixtures(supportDirPath: tempDir.path);

      final metadataDir = Directory(path.join(tempDir.path, 'ModMetadata'));
      final launchTargetsDir =
          Directory(path.join(tempDir.path, 'LaunchTargets'));

      expect(metadataDir.existsSync(), isFalse);
      expect(launchTargetsDir.existsSync(), isFalse);
      expect(Directory(tempDir.path).existsSync(), isTrue);
    });
  });
}
