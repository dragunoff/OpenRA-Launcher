import 'package:http/http.dart' as http;
import 'package:openra_launcher/utils/github_utils.dart';

class AppReleaseUtils {
  static const appRepo = '/dragunoff/OpenRA-Launcher';

  static Future<http.Response> fetchLatestAppRelease() {
    try {
      return http.get(Uri.parse(
          GitHubUtils.buildLatestReleaseEndpoint(AppReleaseUtils.appRepo)));
    } catch (e) {
      return Future.error(e);
    }
  }
}
