import 'package:openra_launcher/domain/entities/app_release.dart';
import 'package:openra_launcher/store/app_update/actions.dart';
import 'package:redux/redux.dart';

final Reducer<AppRelease?> appUpdateReducer = combineReducers([
  TypedReducer<AppRelease?, AppUpdateLoadedAction>(_setLoadedUpdate),
  TypedReducer<AppRelease?, AppUpdateEmptyAction>(_setEpmtyUpdate),
  TypedReducer<AppRelease?, AppUpdateErrorAction>(_setEpmtyUpdate),
]);

AppRelease _setLoadedUpdate(AppRelease? release, AppUpdateLoadedAction action) {
  return action.release;
}

AppRelease? _setEpmtyUpdate(AppRelease? release, action) {
  return null;
}
