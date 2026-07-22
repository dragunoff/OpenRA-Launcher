import 'package:openra_launcher/constants/github_constants.dart';

class GitHubUtils {
  static String buildReleasesEndpoint(String repoEndpoint) {
    return '${GitHubConstants.githubApiUrl}${GitHubConstants.githubReposEndpoint}/$repoEndpoint${GitHubConstants.githubReleasesEndpoint}';
  }

  static String buildLatestReleaseEndpoint(String repoEndpoint) {
    return '${buildReleasesEndpoint(repoEndpoint)}/latest';
  }
}
