import 'package:file/file.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/error_reporter.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/core/platform/support_dir_service.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/services/mod_launch_service.dart'
    show LaunchProcessStarter;
import 'package:path/path.dart' as path;
import 'package:platform/platform.dart';

abstract class ModFoldersService {
  TaskEither<PlatformFailure, Unit> openMapsFolder(Mod mod);
  TaskEither<PlatformFailure, Unit> openReplaysFolder(Mod mod);
}

@LazySingleton(as: ModFoldersService)
class ProcessModFoldersService implements ModFoldersService {
  final SupportDirService supportDirService;
  final FileSystem fileSystem;
  final Platform platform;
  final LaunchProcessStarter starter;
  final ErrorReporter reportError;

  ProcessModFoldersService({
    required this.supportDirService,
    required this.fileSystem,
    required this.platform,
    required this.starter,
    this.reportError = defaultErrorReporter,
  });

  @override
  TaskEither<PlatformFailure, Unit> openMapsFolder(Mod mod) =>
      _openFolder(mod, 'maps');

  @override
  TaskEither<PlatformFailure, Unit> openReplaysFolder(Mod mod) =>
      _openFolder(mod, 'Replays');

  TaskEither<PlatformFailure, Unit> _openFolder(Mod mod, String folder) {
    return supportDirService
        .getAllSupportDirs()
        .mapLeft((failure) => PlatformFailure(failure.message))
        .flatMap(
          (supportDirs) => TaskEither.tryCatch(
            () async {
              final targetPaths = supportDirs
                  .map(
                    (supportDir) => _nearestExistingAncestor(
                      fileSystem.directory(
                        path.join(supportDir.path, folder, mod.id, mod.version),
                      ),
                    ),
                  )
                  .map((directory) => directory.path)
                  .toSet();

              final executable = _fileExplorerCommand();

              for (final targetPath in targetPaths) {
                await starter.start(executable, [targetPath]);
              }

              return unit;
            },
            (error, stackTrace) {
              reportError(
                FlutterErrorDetails(
                  exception: error,
                  stack: stackTrace,
                  library: 'installed_mods',
                  context: ErrorDescription(
                    'opening the $folder of ${mod.title}',
                  ),
                ),
              );

              return PlatformFailure(error.toString());
            },
          ),
        );
  }

  /// Walk up to the closest existing ancestor so that something sensible
  /// opens even when the folder does not exist yet.
  Directory _nearestExistingAncestor(Directory directory) {
    var current = directory;
    while (!current.existsSync()) {
      current = current.parent;
    }
    return current;
  }

  String _fileExplorerCommand() {
    if (platform.isLinux) return 'xdg-open';
    if (platform.isWindows) return 'explorer';
    if (platform.isMacOS) return 'open';

    throw UnsupportedError('Unsupported platform: ${platform.operatingSystem}');
  }
}
