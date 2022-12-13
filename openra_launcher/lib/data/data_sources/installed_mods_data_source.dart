import 'package:file/file.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/exceptions.dart';
import 'package:openra_launcher/core/platform/support_dir_service.dart';
import 'package:openra_launcher/data/models/mod_model.dart';
import 'package:openra_launcher/utils/mod_utils.dart';
import 'package:path/path.dart' as path;

abstract class InstalledModsDataSource {
  /// Scans the support dirs for mod metadata files
  /// and creates mod models from them.
  ///
  /// Throws a [FileSystemException] on error.
  Future<Set<ModModel>> getInstalledMods();
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
  Future<Set<ModModel>> getInstalledMods() async {
    Set<ModModel> mods = {};

    // Several types of support directory types are available, depending on
    // how the player has installed and launched the game.
    // Read registration metadata from all of them
    for (final supportDir in await supportDirService.getAllSupportDirs()) {
      Directory metadataDir =
          fileSystem.directory(path.join(supportDir.path, 'ModMetadata'));

      if (!await metadataDir.exists()) {
        continue;
      }

      await for (final FileSystemEntity file in metadataDir.list()) {
        if (file is! File) {
          continue;
        }

        try {
          _loadMod(file).then((mod) {
            if (mod != null && !ModUtils.isDevMod(mod)) {
              mods.add(mod);
            }
          });
        } catch (e) {
          debugPrint('debug: Failed to parse mod metadata file "${file.path}"');
          debugPrint('debug: ${e.toString()}');
        }
      }
    }

    final sorted = mods.toList();
    sorted.sort();

    return sorted.toSet();
  }

  Future<ModModel?> _loadMod(File file) async {
    ModModel mod;

    try {
      mod = ModModel.fromFile(file);

      if (await fileSystem.file(mod.launchPath).exists() &&
          path.basenameWithoutExtension(file.path) == mod.key) {
        return mod;
      }
    } on MiniYamlFormatException catch (e) {
      debugPrint(e.message);
    } catch (e) {
      throw FileSystemException();
    }

    return Future.value(null);
  }
}
