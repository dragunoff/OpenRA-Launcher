import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:redux/redux.dart';

final modDatabaseStatusReducer = combineReducers<DataStatus>([
  TypedReducer<DataStatus, ModDatabaseLoadedAction>(_setLoaded).call,
  TypedReducer<DataStatus, ModDatabaseEmptyAction>(_setEmpty).call,
  TypedReducer<DataStatus, ModDatabaseErrorAction>(_setError).call,
  TypedReducer<DataStatus, LoadModDatabaseAction>(_setIsLoading).call,
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
