import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/core/network/http_client_service.dart';
import 'package:openra_launcher/features/server_browser/data/models/game_server_model.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';

abstract class ServerListDataSource {
  TaskEither<ServerFailure, List<GameServer>> getServerList();
}

@LazySingleton(as: ServerListDataSource)
class ServerListDataSourceImpl implements ServerListDataSource {
  static final Uri gamesEndpoint = Uri.parse(
    'https://master.openra.net/games?protocol=2&type=json',
  );

  final HttpClientService httpClientService;

  ServerListDataSourceImpl({required this.httpClientService});

  @override
  TaskEither<ServerFailure, List<GameServer>> getServerList() {
    return TaskEither.tryCatch(
      () async {
        final rawResponse = await httpClientService.read(gamesEndpoint);
        final gamesJson = jsonDecode(rawResponse) as List<dynamic>;

        return gamesJson
            .whereType<Map<String, dynamic>>()
            .map(GameServerModel.fromJson)
            .toList();
      },
      (error, stackTrace) {
        return ServerFailure(error.toString());
      },
    );
  }
}
