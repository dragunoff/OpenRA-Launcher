import 'package:openra_launcher/constants/mod_constants.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';

class ModUtils {
  static bool isDevMod(Mod mod) {
    return mod.version == ModConstants.devModVersion;
  }
}
