import 'package:fpdart/fpdart.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';

abstract class ServerListRepository {
  TaskEither<ServerFailure, List<GameServer>> getServerList();
}
