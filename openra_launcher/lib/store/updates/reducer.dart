import 'package:openra_launcher/domain/entities/release.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:redux/redux.dart';

final Reducer<Set<Release>> updatesReducer = combineReducers([
  TypedReducer<Set<Release>, UpdatesLoadedAction>(_setLoadedUpdates),
  TypedReducer<Set<Release>, UpdatesEmptyAction>(_setEpmtyUpdates),
  TypedReducer<Set<Release>, UpdatesErrorAction>(_setEpmtyUpdates),
]);

Set<Release> _setLoadedUpdates(
    Set<Release> releases, UpdatesLoadedAction action) {
  return action.releases;
}

Set<Release> _setEpmtyUpdates(Set<Release> releases, action) {
  return {};
}
