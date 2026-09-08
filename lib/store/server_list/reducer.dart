import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/store/server_list/actions.dart';
import 'package:redux/redux.dart';

final Reducer<List<GameServer>> serverListReducer = combineReducers([
  TypedReducer<List<GameServer>, ServerListLoadedAction>(_setLoaded).call,
  TypedReducer<List<GameServer>, ServerListEmptyAction>(_setEmpty).call,
  TypedReducer<List<GameServer>, ServerListErrorAction>(_setEmpty).call,
]);

List<GameServer> _setLoaded(
  List<GameServer> servers,
  ServerListLoadedAction action,
) {
  return action.servers;
}

List<GameServer> _setEmpty(List<GameServer> servers, action) {
  return [];
}
