import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/utils/mod_utils.dart';
import 'package:openra_launcher/store/app_state.dart';

Set<Mod> selectInstalledMods(AppState state) {
  return state.mods
      .where((mod) =>
          !state.favoriteMods.contains(mod.key) && !ModUtils.isDevMod(mod))
      .toSet();
}

Set<Mod> selectFavoriteMods(AppState state) {
  return state.mods
      .where((mod) => state.favoriteMods.contains(mod.key))
      .toSet();
}

Set<Mod> selectDevMods(AppState state) {
  return state.mods
      .where((mod) =>
          !state.favoriteMods.contains(mod.key) && ModUtils.isDevMod(mod))
      .toSet();
}

Set<String> selectUniqueInstalledModIds(AppState state) {
  return state.mods
      .where((mod) => !ModUtils.isDevMod(mod))
      .fold({}, (previousValue, element) {
    previousValue.add(element.id);
    return previousValue;
  });
}

Mod selectModById(AppState state, String modId) {
  return state.mods.firstWhere((element) => element.id == modId);
}
