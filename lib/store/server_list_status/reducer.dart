import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/server_list/actions.dart';
import 'package:redux/redux.dart';

final serverListStatusReducer = combineReducers<DataStatus>([
  TypedReducer<DataStatus, ServerListLoadedAction>(_setLoaded).call,
  TypedReducer<DataStatus, ServerListEmptyAction>(_setEmpty).call,
  TypedReducer<DataStatus, ServerListErrorAction>(_setError).call,
  TypedReducer<DataStatus, LoadServerListAction>(_setLoading).call,
  TypedReducer<DataStatus, ReloadServerListAction>(_setLoading).call,
]);

DataStatus _setLoaded(DataStatus state, action) {
  return DataStatus.loaded;
}

DataStatus _setLoading(DataStatus state, action) {
  return DataStatus.loading;
}

DataStatus _setEmpty(DataStatus state, action) {
  return DataStatus.empty;
}

DataStatus _setError(DataStatus state, action) {
  return DataStatus.error;
}
