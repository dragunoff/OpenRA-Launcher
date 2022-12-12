import 'package:openra_launcher/store/favorite_mods/actions.dart';
import 'package:redux/redux.dart';

final Reducer<Set<String>> favoriteModsReducer = combineReducers([
  TypedReducer<Set<String>, AddModToFavoritesAction>(_addModToFavorites),
  TypedReducer<Set<String>, RemoveModFromFavoritesAction>(
      _removeModFromFavorites),
]);

Set<String> _removeModFromFavorites(
    Set<String> favoriteMods, RemoveModFromFavoritesAction action) {
  return Set.unmodifiable(Set.from(favoriteMods)..remove(action.mod.key));
}

Set<String> _addModToFavorites(
    Set<String> favoriteMods, AddModToFavoritesAction action) {
  return Set.unmodifiable(Set.from(favoriteMods)..add(action.mod.key));
}
