import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/utils/release_utils.dart';

void main() {
  group('GitHub release endpoint', () {
    test('should build release endpoint from repo ID', () {
      expect(ReleaseUtils.buildGitHubReleasesEndpoint('owner/repo'),
          'https://api.github.com/repos/owner/repo/releases');
    });

    test('should build latest release endpoint from repo ID', () {
      expect(ReleaseUtils.buildGitHubLatestReleaseEndpoint('owner/repo'),
          'https://api.github.com/repos/owner/repo/releases/latest');
    });
  });
}
