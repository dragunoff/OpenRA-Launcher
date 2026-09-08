import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/server_browser/data/data_sources/server_list_data_source.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/features/server_browser/domain/repositories/server_list_repository.abstract.dart';

@LazySingleton(as: ServerListRepository)
class ServerListRepositoryImpl implements ServerListRepository {
  final ServerListDataSource dataSource;

  ServerListRepositoryImpl({required this.dataSource});

  @override
  TaskEither<ServerFailure, List<GameServer>> getServerList() {
    return dataSource.getServerList();
  }
}
