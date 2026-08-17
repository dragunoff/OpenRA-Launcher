import 'package:openra_launcher/store/show_dev_mods/actions.dart';
import 'package:redux/redux.dart';

final showDevModsReducer = combineReducers<bool>([
  TypedReducer<bool, ShowDevModsOn>(_setOn).call,
  TypedReducer<bool, ShowDevModsOff>(_setOff).call,
]);

bool _setOn(bool state, ShowDevModsOn action) {
  return true;
}

bool _setOff(bool state, ShowDevModsOff action) {
  return false;
}
