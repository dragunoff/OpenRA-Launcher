import 'package:file/file.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:platform/platform.dart';
import 'package:xdg_directories/xdg_directories.dart' as xdg;

abstract class SupportDirService {
  TaskEither<FileSystemFailure, Set<Directory>> getAllSupportDirs();
}

@LazySingleton(as: SupportDirService)
class SupportDirServiceImpl implements SupportDirService {
  final Platform platform;
  final FileSystem fileSystem;

  SupportDirServiceImpl({required this.platform, required this.fileSystem});

  @override
  TaskEither<FileSystemFailure, Set<Directory>> getAllSupportDirs() {
    return TaskEither.tryCatch(() async {
      String? systemSupportPath;
      String? modernUserSupportPath;
      String? legacyUserSupportPath;

      if (platform.isLinux) {
        systemSupportPath = '/var/games/openra';
        modernUserSupportPath = path.join(xdg.configHome.path, 'openra');
        legacyUserSupportPath =
            path.join(platform.environment['HOME'] as String, '.openra');
      } else if (platform.isWindows) {
        systemSupportPath = path.join(
          platform.environment['ALLUSERSPROFILE'] as String,
          'OpenRA',
        );
        modernUserSupportPath =
            path.join(platform.environment['APPDATA'] as String, 'OpenRA');

        final docsDir = await getApplicationDocumentsDirectory();
        legacyUserSupportPath = path.join(docsDir.path, 'OpenRA');
      } else if (platform.isMacOS) {
        systemSupportPath = '/Library/Application Support/OpenRA/';
        final appSupportDir = await getApplicationSupportDirectory();
        modernUserSupportPath = legacyUserSupportPath =
            path.join(appSupportDir.parent.path, 'OpenRA');
      } else {
        throw Exception('Unsupported platform: ${platform.operatingSystem}');
      }

      return {
        systemSupportPath,
        modernUserSupportPath,
        legacyUserSupportPath,
      }
          .whereType<String>()
          .map((dirPath) => fileSystem.directory(dirPath))
          .where((element) => element.existsSync())
          .toSet();
    }, (error, stackTrace) {
      return FileSystemFailure(error.toString());
    });
  }
}
