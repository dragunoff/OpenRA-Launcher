import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:openra_launcher/constants/constants.dart';
import 'package:openra_launcher/data/models/mod_model.dart';
import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/utils/platform_utils.dart';
import 'package:openra_launcher/utils/release_utils.dart';
import 'package:path/path.dart' as path;

class ModUtils {
  static Future<Set<Mod>> loadAllMods() async {
    Set<Mod> mods = {};

    // Several types of support directory types are available, depending on
    // how the player has installed and launched the game.
    // Read registration metadata from all of them
    for (var supportDir in await PlatformUtils.getAllSupportDirs()) {
      Directory metadataDir = Directory(path.join(supportDir, 'ModMetadata'));

      if (!await metadataDir.exists()) {
        continue;
      }

      await for (final FileSystemEntity file in metadataDir.list()) {
        if (file is! File) {
          continue;
        }

        try {
          loadMod(file).then((mod) {
            if (mod != null && !isDevMod(mod)) {
              mods.add(mod);
            }
          });
        } catch (e) {
          debugPrint('debug: Failed to parse mod metadata file "${file.path}"');
          debugPrint('debug: ${e.toString()}');
        }
      }
    }

    var sorted = mods.toList();
    sorted.sort();

    return sorted.toSet();
  }

  static Future<Mod?> loadMod(File file) async {
    var mod = ModModel.fromFile(file);

    // NOTE: Explicitly invalidate paths to OpenRA.dll to clean up bogus metadata files
    // that were created after the initial migration from .NET Framework to Core/5.
    // (this is a hack copied from OpenRA source)
    if (await File(mod.launchPath).exists() &&
        path.basenameWithoutExtension(file.path) == mod.key &&
        path.extension(mod.launchPath) != '.dll') {
      return mod;
    }

    return Future.value(null);
  }

  // TODO: Extract this into a service
  static Future<Process> launchMod(Mod mod) async {
    // TODO: Handle errors on mod launch
    return Process.start(
      mod.launchPath,
      mod.launchArgs,
      runInShell: true,
      mode: ProcessStartMode.detached,
    );
  }

  static bool isOfficialMod(Mod mod) {
    return Constants.officialModIds.contains(mod.id);
  }

  static bool isDevMod(Mod mod) {
    return mod.version == Constants.devModVersion;
  }

  static bool isSupportedForUpdates(String modId) {
    return ReleaseUtils.getSupportedMods().contains(modId);
  }
}
