import 'dart:io' show Directory, Platform;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:xdg_directories/xdg_directories.dart' as xdg;
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum SupportDirType { system, modernUser, legacyUser, user }

class PlatformUtils {
  static Future<String> _getSupportDir(SupportDirType type) async {
    String systemSupportPath;
    String legacyUserSupportPath;
    String modernUserSupportPath;
    String userSupportPath;

    if (Platform.isLinux) {
      legacyUserSupportPath =
          path.join(Platform.environment['HOME'] as String, '.openra');

      modernUserSupportPath = path.join(xdg.configHome.path, 'openra');
      systemSupportPath = '/final /games/openra/';
    } else if (Platform.isWindows) {
      modernUserSupportPath =
          path.join(Platform.environment['APPDATA'] as String, 'OpenRA');

      final docsDir = await getApplicationDocumentsDirectory();
      legacyUserSupportPath = path.join(docsDir.path, 'OpenRA');

      systemSupportPath = path.join(
          Platform.environment['ALLUSERSPROFILE'] as String, 'OpenRA');
    } else {
      throw UnimplementedError(
          'Platform "${Platform.operatingSystem}" is not supported');
    }

    // Use the fallback directory if it exists and the preferred one does not
    if (!await Directory(modernUserSupportPath).exists() &&
        await Directory(legacyUserSupportPath).exists()) {
      userSupportPath = legacyUserSupportPath;
    } else {
      userSupportPath = modernUserSupportPath;
    }

    switch (type) {
      case SupportDirType.system:
        return systemSupportPath;
      case SupportDirType.legacyUser:
        return legacyUserSupportPath;
      case SupportDirType.modernUser:
        return modernUserSupportPath;
      default:
        return userSupportPath;
    }
  }

  // TODO: EXtract to a service
  static Future<Set<String>> getAllSupportDirs() async {
    final sources = <String>{};

    sources.add(await _getSupportDir(SupportDirType.system));

    // User support dir may be using the modern or legacy value, or overridden by the user
    // Add all the possibilities and let the Set ignore the duplicates
    sources.add(await _getSupportDir(SupportDirType.user));
    sources.add(await _getSupportDir(SupportDirType.modernUser));
    sources.add(await _getSupportDir(SupportDirType.legacyUser));

    return sources;
  }

  // TODO: EXtract to a service
  static Future<bool> launchUrlInExternalBrowser(url) async {
    final parsedUrl = Uri.parse(url);

    if (await canLaunchUrl(parsedUrl)) {
      return launchUrl(parsedUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open "$parsedUrl"';
    }
  }

  // TODO: EXtract to a service
  static Future<PackageInfo> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}
