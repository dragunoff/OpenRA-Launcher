import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/store/server_status_filter/actions.dart';
import 'package:redux/redux.dart';

final Reducer<Set<GameServerStatus>> serverStatusFilterReducer =
    combineReducers([
      TypedReducer<Set<GameServerStatus>, ToggleServerStatusFilterAction>(
        _toggleStatus,
      ).call,
    ]);

Set<GameServerStatus> _toggleStatus(
  Set<GameServerStatus> visibleStatuses,
  ToggleServerStatusFilterAction action,
) {
  final next = Set.of(visibleStatuses);
  if (!next.remove(action.status)) {
    next.add(action.status);
  }
  return Set.unmodifiable(next);
}
