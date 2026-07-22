import 'package:http/http.dart' as http;
import 'package:openra_launcher/constants/github_constants.dart';
import 'package:openra_launcher/utils/github_utils.dart';

class AppReleaseUtils {
  static Future<http.Response> fetchLatestAppRelease() {
    try {
      return http.get(Uri.parse(
          GitHubUtils.buildLatestReleaseEndpoint(GitHubConstants.appRepo)));
    } catch (e) {
      return Future.error(e);
    }
  }
}
