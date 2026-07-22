import 'package:http/http.dart' as http;
import 'package:openra_launcher/constants/github_constants.dart';

class ReleaseUtils {
  static Future<http.Response> fetchLatestAppRelease() {
    try {
      return http
          .get(Uri.parse(buildGitHubLatestReleaseEndpoint(GitHubConstants.appRepo)));
    } catch (e) {
      return Future.error(e);
    }
  }

  static String buildGitHubReleasesEndpoint(String repoEndpoint) {
    return '${GitHubConstants.githubApiUrl}${GitHubConstants.githubReposEndpoint}/$repoEndpoint${GitHubConstants.githubReleasesEndpoint}';
  }

  static String buildGitHubLatestReleaseEndpoint(String repoEndpoint) {
    return '${buildGitHubReleasesEndpoint(repoEndpoint)}/latest';
  }
}
