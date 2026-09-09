import 'package:openra_launcher/store/collapsed_mod_groups/actions.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:redux/redux.dart';

final Reducer<Set<String>> collapsedModGroupsReducer = combineReducers([
  TypedReducer<Set<String>, ToggleCollapsedModGroupAction>(_toggle).call,
  TypedReducer<Set<String>, ModsLoadedAction>(_cleanMissing).call,
  TypedReducer<Set<String>, ModsEmptyAction>(_clear).call,
]);

Set<String> _toggle(
  Set<String> collapsedGroups,
  ToggleCollapsedModGroupAction action,
) {
  final next = Set<String>.from(collapsedGroups);
  if (!next.add(action.groupKey)) {
    next.remove(action.groupKey);
  }
  return Set.unmodifiable(next);
}

Set<String> _cleanMissing(
  Set<String> collapsedGroups,
  ModsLoadedAction action,
) {
  final existingModKeys = action.mods.map((mod) => mod.key).toSet();
  return Set.unmodifiable(
    Set.from(collapsedGroups)..retainAll(existingModKeys),
  );
}

Set<String> _clear(Set<String> collapsedGroups, ModsEmptyAction action) {
  return const {};
}
