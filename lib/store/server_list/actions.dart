import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';

class LoadServerListAction {}

class ReloadServerListAction {}

class ServerListLoadedAction {
  final List<GameServer> servers;

  ServerListLoadedAction(this.servers);
}

class ServerListEmptyAction {}

class ServerListErrorAction {}
