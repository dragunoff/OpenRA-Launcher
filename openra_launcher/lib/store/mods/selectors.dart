import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/utils/mod_utils.dart';

Set<Mod> selectOfficialMods(AppState state) {
  return state.mods
      .where((mod) => ModUtils.isOfficialMod(mod))
      .where((mod) => !state.favoriteMods.contains(mod.key))
      .toSet();
}

Set<Mod> selectCommunityMods(AppState state) {
  return state.mods
      .where((mod) => !ModUtils.isOfficialMod(mod))
      .where((mod) => !state.favoriteMods.contains(mod.key))
      .toSet();
}

Set<Mod> selectFavoriteMods(AppState state) {
  return state.mods
      .where((mod) => state.favoriteMods.contains(mod.key))
      .toSet();
}

Set<String> selectUniqueInstalledModIds(AppState state) {
  return state.mods.fold({}, (previousValue, element) {
    previousValue.add(element.id);
    return previousValue;
  });
}

Mod selectModById(AppState state, String modId) {
  return state.mods.firstWhere((element) => element.id == modId);
}
