import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:redux/redux.dart';

final updatesListStatusReducer = combineReducers<ListStatus>([
  TypedReducer<ListStatus, ModDatabaseLoadedAction>(_setLoaded).call,
  TypedReducer<ListStatus, ModDatabaseEmptyAction>(_setEmpty).call,
  TypedReducer<ListStatus, ModDatabaseErrorAction>(_setError).call,
  TypedReducer<ListStatus, LoadModDatabaseAction>(_setIsLoading).call,
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
