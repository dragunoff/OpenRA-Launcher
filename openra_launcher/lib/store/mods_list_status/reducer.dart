import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/mods/actions.dart';
import 'package:redux/redux.dart';

final modsListStatusReducer = combineReducers<ListStatus>([
  TypedReducer<ListStatus, ModsLoadedAction>(_setLoaded),
  TypedReducer<ListStatus, ModsEmptyAction>(_setEmpty),
  TypedReducer<ListStatus, ModsErrorAction>(_setError),
  TypedReducer<ListStatus, LoadModsAction>(_setIsLoading),
  TypedReducer<ListStatus, ReloadModsAction>(_setIsLoading),
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
