import 'package:openra_launcher/store/hidden_mods/actions.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:redux/redux.dart';

final Reducer<Set<String>> hiddenModsReducer = combineReducers([
  TypedReducer<Set<String>, HideModAction>(_hideMod).call,
  TypedReducer<Set<String>, UnhideModAction>(_unhideMod).call,
  TypedReducer<Set<String>, ModsLoadedAction>(_cleanMissingHidden).call,
  TypedReducer<Set<String>, ModsEmptyAction>(_clearHidden).call,
]);

Set<String> _cleanMissingHidden(
  Set<String> hiddenMods,
  ModsLoadedAction action,
) {
  final existingModKeys = action.mods.map((mod) => mod.key).toSet();
  return Set.unmodifiable(Set.from(hiddenMods)..retainAll(existingModKeys));
}

Set<String> _clearHidden(Set<String> hiddenMods, ModsEmptyAction action) {
  return const {};
}

Set<String> _unhideMod(Set<String> hiddenMods, UnhideModAction action) {
  return Set.unmodifiable(Set.from(hiddenMods)..remove(action.mod.key));
}

Set<String> _hideMod(Set<String> hiddenMods, HideModAction action) {
  return Set.unmodifiable(Set.from(hiddenMods)..add(action.mod.key));
}
