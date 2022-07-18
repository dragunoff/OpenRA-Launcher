import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/data/models/app_release_model.dart';
import 'package:openra_launcher/domain/entities/app_release.dart';

import '../../../utils/test_utils.dart';

void main() {
  group('App Release model', () {
    const testObj = AppReleaseModel(
      id: 1,
      version: 'version',
      name: 'Test App Release',
      htmlUrl: 'https://example.com',
    );

    test(
      'should be a subclass of App Release entity',
      () {
        expect(testObj, isA<AppRelease>());
      },
    );

    test('should construct object from decoded JSON', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
          TestUtils.getJsonStringFromFile(
              'github_json/release-playtest.json'))[0];

      // act
      final result = AppReleaseModel.fromJson(jsonMap);

      // assert
      expect(result, isA<AppRelease>());
      expect(result.id, jsonMap['id']);
      expect(result.name, jsonMap['name']);
      expect(result.version, jsonMap['tag_name']);
      expect(result.htmlUrl, jsonMap['html_url']);
    });
  });
}
