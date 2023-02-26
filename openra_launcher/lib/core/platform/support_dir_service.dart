import 'package:file/file.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:platform/platform.dart';
import 'package:xdg_directories/xdg_directories.dart' as xdg;

abstract class SupportDirService {
  /// Provides a set of all available support directories.
  Future<Set<Directory>> getAllSupportDirs();
}

@LazySingleton(as: SupportDirService)
class SupportDirServiceImpl implements SupportDirService {
  final Platform platform;
  final FileSystem fileSystem;

  SupportDirServiceImpl({required this.platform, required this.fileSystem});

  @override
  Future<Set<Directory>> getAllSupportDirs() async {
    String systemSupportPath;
    String modernUserSupportPath;
    String legacyUserSupportPath;

    // Linux
    if (platform.isLinux) {
      systemSupportPath = '/var/games/openra';
      modernUserSupportPath = path.join(xdg.configHome.path, 'openra');
      legacyUserSupportPath =
          path.join(platform.environment['HOME'] as String, '.openra');
    }
    // Windows
    else if (platform.isWindows) {
      systemSupportPath = path.join(
          platform.environment['ALLUSERSPROFILE'] as String, 'OpenRA');
      modernUserSupportPath =
          path.join(platform.environment['APPDATA'] as String, 'OpenRA');

      final docsDir = await getApplicationDocumentsDirectory();
      legacyUserSupportPath = path.join(docsDir.path, 'OpenRA');
    }
    // MacOS
    else if (platform.isMacOS) {
      systemSupportPath = '/Library/Application Support/OpenRA/';
      final appSupportDir = await getApplicationSupportDirectory();
      modernUserSupportPath = legacyUserSupportPath =
          path.join(appSupportDir.parent.path, 'OpenRA');
    }
    // Others not supported
    else {
      throw Exception(
          'Platform "${platform.operatingSystem}" is not supported');
    }

    final allSupportDirs = {
      systemSupportPath,
      modernUserSupportPath,
      legacyUserSupportPath
    }
        .map((path) => fileSystem.directory(path))
        .where((element) => element.existsSync())
        .toSet();

    return Future.value(allSupportDirs);
  }
}
