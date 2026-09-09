import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/core/version_service.dart';

void main() {
  group('VersionServiceImpl', () {
    final reportedErrors = <FlutterErrorDetails>[];
    VersionServiceImpl service() =>
        VersionServiceImpl(reportError: reportedErrors.add);

    setUp(() => reportedErrors.clear());

    test('returns false for identical stable versions', () {
      expect(service().isNewerVersion('1.1.0', '1.1.0'), false);
    });

    test('returns true when latest stable is newer', () {
      expect(service().isNewerVersion('1.1.1', '1.1.0'), true);
    });

    test(
      'returns false when latest prerelease is older than installed stable',
      () {
        expect(service().isNewerVersion('1.1.0-beta.1', '1.1.0'), false);
      },
    );

    test(
      'returns true when latest prerelease is newer than installed prerelease',
      () {
        expect(service().isNewerVersion('1.1.0-beta.2', '1.1.0-beta.1'), true);
      },
    );

    test(
      'returns true when latest stable is newer than installed prerelease',
      () {
        expect(service().isNewerVersion('1.1.0', '1.0.9-beta.2'), true);
      },
    );

    test('handles leading v prefix correctly', () {
      expect(service().isNewerVersion('v1.1.0', '1.0.9'), true);
    });

    test('reports the error when version parsing fails', () {
      expect(service().isNewerVersion('not-a-version', '1.0.9'), true);
      expect(reportedErrors.length, 1);
    });
  });
}
