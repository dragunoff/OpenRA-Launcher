import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/utils/version_utils.dart';

void main() {
  group('VersionUtils', () {
    test('returns false for identical stable versions', () {
      expect(VersionUtils.isNewerVersion('1.1.0', '1.1.0'), false);
    });

    test('returns true when latest stable is newer', () {
      expect(VersionUtils.isNewerVersion('1.1.1', '1.1.0'), true);
    });

    test('returns false when latest prerelease is older than installed stable',
        () {
      expect(VersionUtils.isNewerVersion('1.1.0-beta.1', '1.1.0'), false);
    });

    test(
        'returns true when latest prerelease is newer than installed prerelease',
        () {
      expect(VersionUtils.isNewerVersion('1.1.0-beta.2', '1.1.0-beta.1'), true);
    });

    test('returns true when latest stable is newer than installed prerelease',
        () {
      expect(VersionUtils.isNewerVersion('1.1.0', '1.0.9-beta.2'), true);
    });

    test('handles leading v prefix correctly', () {
      expect(VersionUtils.isNewerVersion('v1.1.0', '1.0.9'), true);
    });
  });
}
