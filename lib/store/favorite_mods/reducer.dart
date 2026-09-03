import 'package:openra_launcher/store/favorite_mods/actions.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:redux/redux.dart';

final Reducer<Set<String>> favoriteModsReducer = combineReducers([
  TypedReducer<Set<String>, AddModToFavoritesAction>(_addModToFavorites).call,
  TypedReducer<Set<String>, RemoveModFromFavoritesAction>(
    _removeModFromFavorites,
  ).call,
  TypedReducer<Set<String>, ModsLoadedAction>(_cleanMissingFavorites).call,
  TypedReducer<Set<String>, ModsEmptyAction>(_clearFavorites).call,
]);

Set<String> _cleanMissingFavorites(
  Set<String> favoriteMods,
  ModsLoadedAction action,
) {
  final existingModKeys = action.mods.map((mod) => mod.key).toSet();
  return Set.unmodifiable(Set.from(favoriteMods)..retainAll(existingModKeys));
}

Set<String> _clearFavorites(Set<String> favoriteMods, ModsEmptyAction action) {
  return const {};
}

Set<String> _removeModFromFavorites(
  Set<String> favoriteMods,
  RemoveModFromFavoritesAction action,
) {
  return Set.unmodifiable(Set.from(favoriteMods)..remove(action.mod.key));
}

Set<String> _addModToFavorites(
  Set<String> favoriteMods,
  AddModToFavoritesAction action,
) {
  return Set.unmodifiable(Set.from(favoriteMods)..add(action.mod.key));
}
