import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:redux/redux.dart';

final updatesListStatusReducer = combineReducers<ListStatus>([
  TypedReducer<ListStatus, UpdatesLoadedAction>(_setLoaded),
  TypedReducer<ListStatus, UpdatesEmptyAction>(_setEmpty),
  TypedReducer<ListStatus, UpdatesErrorAction>(_setError),
  TypedReducer<ListStatus, LoadUpdatesAction>(_setIsLoading),
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
