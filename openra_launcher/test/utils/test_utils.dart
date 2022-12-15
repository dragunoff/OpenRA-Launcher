import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:openra_launcher/constants/constants.dart';
import 'package:openra_launcher/data/models/release_model.dart';
import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/domain/entities/release.dart';

class TestUtils {
  static Release generateRelease() {
    return const Release(
      modId: 'test-mod',
      id: 1,
      name: 'Test Release',
      version: 'version',
      isPlaytest: false,
      htmlUrl: 'https://example.com',
    );
  }

  static ReleaseModel generateReleaseModel() {
    return const ReleaseModel(
      modId: 'test-mod',
      id: 1,
      name: 'Test Release',
      version: 'version',
      isPlaytest: false,
      htmlUrl: 'https://example.com',
    );
  }

  static Mod generateMod() {
    return const Mod(
      key: 'test-version',
      id: 'test',
      version: 'version',
      title: 'Test Mod',
      launchPath: '',
      launchArgs: [''],
    );
  }

  static Mod generateRandomOfficialMod() {
    return generateMod().copyWith(
        id: Constants
            .officialModIds[Random().nextInt(Constants.officialModIds.length)]);
  }

  static String getTestPngBase64() {
    return 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8Xw8AAoMBgDTD2qgAAAAASUVORK5CYII=';
  }

  static Uint8List getTestPng() {
    return const Base64Decoder().convert(getTestPngBase64());
  }

  static File getYamlFile(String filename) {
    return File('./test/fixtures/yaml/$filename');
  }

  static String getJsonStringFromFile(String filename) {
    return File('./test/fixtures/$filename').readAsStringSync();
  }
}
