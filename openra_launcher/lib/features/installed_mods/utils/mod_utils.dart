import 'dart:io';

import 'package:openra_launcher/constants/mod_constants.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';

class ModUtils {
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
    return ModConstants.officialModIds.contains(mod.id);
  }

  static bool isDevMod(Mod mod) {
    return mod.version == ModConstants.devModVersion;
  }

  static bool isSupportedForUpdates(String modId) {
    final supported = Set.from(ModConstants.modRepos.keys)
      ..addAll(ModConstants.officialModIds)
      ..remove('openra');

    return supported.contains(modId);
  }
}
