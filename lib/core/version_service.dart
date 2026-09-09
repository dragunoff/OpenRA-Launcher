import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/error_reporter.dart';
import 'package:pub_semver/pub_semver.dart';

abstract class VersionService {
  bool isNewerVersion(String latestVersion, String currentVersion);
}

@LazySingleton(as: VersionService)
class VersionServiceImpl implements VersionService {
  final ErrorReporter reportError;

  VersionServiceImpl({this.reportError = defaultErrorReporter});

  String _normalizeVersion(String version) {
    return version.trim().replaceFirst(RegExp(r'^v', caseSensitive: false), '');
  }

  @override
  bool isNewerVersion(String latestVersion, String currentVersion) {
    try {
      final parsedLatest = Version.parse(_normalizeVersion(latestVersion));
      final parsedCurrent = Version.parse(_normalizeVersion(currentVersion));

      return parsedLatest > parsedCurrent;
    } catch (e, stackTrace) {
      reportError(
        FlutterErrorDetails(
          exception: e,
          stack: stackTrace,
          library: 'core',
          context: ErrorDescription('comparing version strings'),
        ),
      );

      return latestVersion != currentVersion;
    }
  }
}
