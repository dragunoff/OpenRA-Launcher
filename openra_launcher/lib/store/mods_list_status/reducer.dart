import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:redux/redux.dart';

final modsListStatusReducer = combineReducers<ListStatus>([
  TypedReducer<ListStatus, ModsLoadedAction>(_setLoaded).call,
  TypedReducer<ListStatus, ModsEmptyAction>(_setEmpty).call,
  TypedReducer<ListStatus, ModsErrorAction>(_setError).call,
  TypedReducer<ListStatus, LoadModsAction>(_setIsLoading).call,
  TypedReducer<ListStatus, ReloadModsAction>(_setIsLoading).call,
]);

ListStatus _setLoaded(ListStatus state, action) {
  return ListStatus.loaded;
}

ListStatus _setIsLoading(ListStatus state, action) {
  return ListStatus.loading;
}

ListStatus _setEmpty(ListStatus state, action) {
  return ListStatus.empty;
}

ListStatus _setError(ListStatus state, action) {
  return ListStatus.error;
}
