import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:redux/redux.dart';

final Reducer<Set<Mod>> modsReducer = combineReducers([
  TypedReducer<Set<Mod>, ModsLoadedAction>(_setLoadedMods).call,
  TypedReducer<Set<Mod>, ModsEmptyAction>(_setEmptyMods).call,
  TypedReducer<Set<Mod>, ModsErrorAction>(_setEmptyMods).call,
]);

Set<Mod> _setLoadedMods(Set<Mod> mods, ModsLoadedAction action) {
  return action.mods;
}

Set<Mod> _setEmptyMods(Set<Mod> mods, action) {
  return {};
}
