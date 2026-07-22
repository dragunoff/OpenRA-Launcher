import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:redux/redux.dart';

final Reducer<Set<Release>> updatesReducer = combineReducers([
  TypedReducer<Set<Release>, UpdatesLoadedAction>(_setLoadedUpdates).call,
  TypedReducer<Set<Release>, UpdatesEmptyAction>(_setEpmtyUpdates).call,
  TypedReducer<Set<Release>, UpdatesErrorAction>(_setEpmtyUpdates).call,
]);

Set<Release> _setLoadedUpdates(
    Set<Release> releases, UpdatesLoadedAction action) {
  return action.releases;
}

Set<Release> _setEpmtyUpdates(Set<Release> releases, action) {
  return {};
}
