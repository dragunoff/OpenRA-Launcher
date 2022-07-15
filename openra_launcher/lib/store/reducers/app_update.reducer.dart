import 'package:openra_launcher/models/app_release.dart';
import 'package:openra_launcher/store/actions.dart';
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
