import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/error_reporter.dart';
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
  final ErrorReporter reportError;

  ServerListDataSourceImpl({
    required this.httpClientService,
    this.reportError = defaultErrorReporter,
  });

  @override
  TaskEither<ServerFailure, List<GameServer>> getServerList() {
    return TaskEither.tryCatch(
      () async {
        final rawResponse = await httpClientService.read(gamesEndpoint);
        final gamesJson = jsonDecode(rawResponse) as List<dynamic>;

        // Ignore any invalid games advertised, reporting the parse error,
        // mirroring the behavior of the in-game server browser.
        final games = <GameServer>[];
        for (final game in gamesJson.whereType<Map<String, dynamic>>()) {
          (await GameServerModel.parse(game).run()).match(
            (failure) => reportError(
              FlutterErrorDetails(
                exception: failure.exception,
                stack: failure.stackTrace,
              ),
            ),
            (server) => games.add(server),
          );
        }

        return games;
      },
      (error, stackTrace) {
        return ServerFailure(error.toString());
      },
    );
  }
}
