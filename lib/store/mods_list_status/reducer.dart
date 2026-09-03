import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:redux/redux.dart';

final modsListStatusReducer = combineReducers<DataStatus>([
  TypedReducer<DataStatus, ModsLoadedAction>(_setLoaded).call,
  TypedReducer<DataStatus, ModsEmptyAction>(_setEmpty).call,
  TypedReducer<DataStatus, ModsErrorAction>(_setError).call,
  TypedReducer<DataStatus, LoadModsAction>(_setIsLoading).call,
  TypedReducer<DataStatus, ReloadModsAction>(_setIsLoading).call,
]);

DataStatus _setLoaded(DataStatus state, action) {
  return DataStatus.loaded;
}

DataStatus _setIsLoading(DataStatus state, action) {
  return DataStatus.loading;
}

DataStatus _setEmpty(DataStatus state, action) {
  return DataStatus.empty;
}

DataStatus _setError(DataStatus state, action) {
  return DataStatus.error;
}
