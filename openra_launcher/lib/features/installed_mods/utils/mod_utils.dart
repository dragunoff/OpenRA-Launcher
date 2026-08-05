import 'package:openra_launcher/constants/mod_constants.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';

class ModUtils {
  static final Set<String> supportedForUpdates =
      Set.from(ModConstants.modRepos.keys)
        ..addAll(ModConstants.officialModIds)
        ..remove('openra');

  static bool isDevMod(Mod mod) {
    return mod.version == ModConstants.devModVersion;
  }

  static bool isSupportedForUpdates(String modId) {
    return supportedForUpdates.contains(modId);
  }
}
