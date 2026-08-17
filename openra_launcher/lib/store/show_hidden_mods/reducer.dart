import 'package:openra_launcher/store/show_hidden_mods/actions.dart';
import 'package:redux/redux.dart';

final showHiddenModsReducer = combineReducers<bool>([
  TypedReducer<bool, ShowHiddenModsOn>(_setOn).call,
  TypedReducer<bool, ShowHiddenModsOff>(_setOff).call,
]);

bool _setOn(bool state, ShowHiddenModsOn action) {
  return true;
}

bool _setOff(bool state, ShowHiddenModsOff action) {
  return false;
}
