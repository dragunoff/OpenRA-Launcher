import 'package:http/http.dart' as http;
import 'package:openra_launcher/constants/constants.dart';

class ReleaseUtils {
  static Future<http.Response> fetchLatestAppRelease() {
    try {
      return http
          .get(Uri.parse(buildGitHubLatestReleaseEndpoint(Constants.appRepo)));
    } catch (e) {
      return Future.error(e);
    }
  }

  static String buildGitHubReleasesEndpoint(String repoEndpoint) {
    return '${Constants.githubApiUrl}${Constants.githubReposEndpoint}/$repoEndpoint${Constants.githubReleasesEndpoint}';
  }

  static String buildGitHubLatestReleaseEndpoint(String repoEndpoint) {
    return '${buildGitHubReleasesEndpoint(repoEndpoint)}/latest';
  }
}
