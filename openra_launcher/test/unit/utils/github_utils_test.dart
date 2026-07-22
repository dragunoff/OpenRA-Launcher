import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/utils/github_utils.dart';

void main() {
  group('GitHubUtils', () {
    group('buildReleasesEndpoint', () {
      test('should build release endpoint from repo ID', () {
        expect(GitHubUtils.buildReleasesEndpoint('owner/repo'),
            'https://api.github.com/repos/owner/repo/releases');
      });
    });

    group('buildLatestReleaseEndpoint', () {
      test('should build latest release endpoint from repo ID', () {
        expect(GitHubUtils.buildLatestReleaseEndpoint('owner/repo'),
            'https://api.github.com/repos/owner/repo/releases/latest');
      });
    });
  });
}
