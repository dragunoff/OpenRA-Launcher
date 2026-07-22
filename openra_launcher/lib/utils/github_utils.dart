class GitHubUtils {
  static const githubApiUrl = 'https://api.github.com';
  static const githubReposEndpoint = '/repos';
  static const githubReleasesEndpoint = '/releases';

  static String buildReleasesEndpoint(String repoEndpoint) {
    return '${GitHubUtils.githubApiUrl}${GitHubUtils.githubReposEndpoint}/$repoEndpoint${GitHubUtils.githubReleasesEndpoint}';
  }

  static String buildLatestReleaseEndpoint(String repoEndpoint) {
    return '${buildReleasesEndpoint(repoEndpoint)}/latest';
  }
}
