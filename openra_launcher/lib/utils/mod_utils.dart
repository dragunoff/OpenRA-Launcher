import 'dart:io';

import 'package:openra_launcher/constants/constants.dart';
import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/utils/release_utils.dart';

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
    return Constants.officialModIds.contains(mod.id);
  }

  static bool isDevMod(Mod mod) {
    return mod.version == Constants.devModVersion;
  }

  static bool isSupportedForUpdates(String modId) {
    return ReleaseUtils.getSupportedMods().contains(modId);
  }
}
