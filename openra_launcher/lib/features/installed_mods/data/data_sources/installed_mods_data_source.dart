import 'package:file/file.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/core/platform/support_dir_service.dart';
import 'package:openra_launcher/features/installed_mods/data/models/mod_model.dart';
import 'package:openra_launcher/features/installed_mods/utils/mod_utils.dart';
import 'package:path/path.dart' as path;

abstract class InstalledModsDataSource {
  TaskEither<FileSystemFailure, Set<ModModel>> getInstalledMods();
}

@LazySingleton(as: InstalledModsDataSource)
class InstalledModsDataSourceImpl implements InstalledModsDataSource {
  final FileSystem fileSystem;
  final SupportDirService supportDirService;

  InstalledModsDataSourceImpl({
    required this.fileSystem,
    required this.supportDirService,
  });

  @override
  TaskEither<FileSystemFailure, Set<ModModel>> getInstalledMods() {
    // Several types of support directory types are available, depending on
    // how the player has installed and launched the game.
    // Read registration metadata from all of them
    return supportDirService.getAllSupportDirs().map((supportDirs) {
      return supportDirs
          .map((supportDir) {
            final metadataDir =
                fileSystem.directory(path.join(supportDir.path, 'ModMetadata'));
            return metadataDir;
          })
          .where((metadataDir) => metadataDir.existsSync())
          .toSet();
    }).map((modMetadataDirs) {
      return modMetadataDirs
          .expand((metadataDir) => metadataDir.listSync().whereType<File>())
          .toSet();
    }).map((metadataFiles) {
      return metadataFiles
          .map((file) {
            try {
              final mod = ModModel.fromFile(file);
              if (fileSystem.file(mod.launchPath).existsSync() &&
                  path.basenameWithoutExtension(file.path) == mod.key &&
                  !ModUtils.isDevMod(mod)) {
                return mod;
              }
            } catch (error, stackTrace) {
              FlutterError.reportError(FlutterErrorDetails(
                exception: error,
                stack: stackTrace,
              ));
            }
            return null;
          })
          .whereType<ModModel>()
          .toSet();
    }).map((mods) {
      final sorted = mods.toList();
      sorted.sort();
      return sorted.toSet();
    });
  }
}
