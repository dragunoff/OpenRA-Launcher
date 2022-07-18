import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/store/actions.dart';
import 'package:redux/redux.dart';

final Reducer<Set<Mod>> modsReducer = combineReducers([
  TypedReducer<Set<Mod>, ModsLoadedAction>(_setLoadedMods),
  TypedReducer<Set<Mod>, ModsEmptyAction>(_setEmptyMods),
  TypedReducer<Set<Mod>, ModsErrorAction>(_setEmptyMods),
]);

Set<Mod> _setLoadedMods(Set<Mod> mods, ModsLoadedAction action) {
  return action.mods;
}

Set<Mod> _setEmptyMods(Set<Mod> mods, action) {
  return {};
}
