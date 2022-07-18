import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/data/models/release_model.dart';
import 'package:openra_launcher/domain/entities/release.dart';

import '../../../utils/test_utils.dart';

void main() {
  group('Release model', () {
    const testObj = ReleaseModel(
      modId: 'test',
      id: 1,
      version: 'version',
      name: 'Test Release',
      htmlUrl: 'https://example.com',
      isPlaytest: false,
    );

    test(
      'should be a subclass of Release entity',
      () {
        expect(testObj, isA<Release>());
      },
    );

    test('should construct object from decoded JSON', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
          TestUtils.getJsonStringFromFile(
              'github_json/release-playtest.json'))[0];

      // act
      final result = ReleaseModel.fromJson('test', jsonMap);

      // assert
      expect(result, isA<Release>());
      expect(result.modId, 'test');
      expect(result.id, jsonMap['id']);
      expect(result.name, jsonMap['name']);
      expect(result.version, jsonMap['tag_name']);
      expect(result.htmlUrl, jsonMap['html_url']);
    });
  });
}
