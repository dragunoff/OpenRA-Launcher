import 'package:openra_launcher/store/auto_check_app_updates/actions.dart';
import 'package:redux/redux.dart';

final autoCheckAppUpdatesReducer = combineReducers<bool>([
  TypedReducer<bool, AutoCheckForAppUpdatesOn>(_setOn),
  TypedReducer<bool, AutoCheckForAppUpdatesOff>(_setOff),
]);

bool _setOn(bool state, AutoCheckForAppUpdatesOn action) {
  return true;
}

bool _setOff(bool state, AutoCheckForAppUpdatesOff action) {
  return false;
}
