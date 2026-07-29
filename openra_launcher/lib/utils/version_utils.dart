import 'package:pub_semver/pub_semver.dart';

class VersionUtils {
  static String _normalizeVersion(String version) {
    return version.trim().replaceFirst(RegExp(r'^v', caseSensitive: false), '');
  }

  static bool isNewerVersion(String latestVersion, String currentVersion) {
    try {
      final parsedLatest = Version.parse(_normalizeVersion(latestVersion));
      final parsedCurrent = Version.parse(_normalizeVersion(currentVersion));

      return parsedLatest > parsedCurrent;
    } catch (_) {
      return latestVersion != currentVersion;
    }
  }
}
