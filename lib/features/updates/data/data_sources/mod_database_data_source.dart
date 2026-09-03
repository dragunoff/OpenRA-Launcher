import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/constants/mod_constants.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/core/network/http_client_service.dart';
import 'package:openra_launcher/features/updates/data/models/mod_database_model.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database.dart';
import 'package:openra_launcher/utils/github_utils.dart';

abstract class ModDatabaseDataSource {
  TaskEither<ServerFailure, ModDatabase> getModDatabase();
}

@LazySingleton(as: ModDatabaseDataSource)
class ModDatabaseDataSourceImpl implements ModDatabaseDataSource {
  final Uri releaseEndpoint = Uri.parse(
    GitHubUtils.buildLatestReleaseEndpoint(ModConstants.modDatabaseRepo),
  );

  final HttpClientService httpClientService;

  ModDatabaseDataSourceImpl({required this.httpClientService});

  @override
  TaskEither<ServerFailure, ModDatabase> getModDatabase() {
    return TaskEither.tryCatch(
      () async {
        final rawResponse = await httpClientService.read(releaseEndpoint);
        final releaseJson = jsonDecode(rawResponse) as Map<String, dynamic>;
        final assetUrl = _getDatabaseAssetUrl(releaseJson);

        final databaseResponse = await httpClientService.read(
          Uri.parse(assetUrl),
        );
        final database = jsonDecode(databaseResponse) as Map<String, dynamic>;

        return ModDatabaseModel.fromJson(database);
      },
      (error, stackTrace) {
        return ServerFailure(error.toString());
      },
    );
  }

  /// Extracts the `browser_download_url` of the [ModConstants.modDatabaseAssetName]
  /// asset from a GitHub release object.
  static String _getDatabaseAssetUrl(Map<String, dynamic> releaseJson) {
    final assets = releaseJson['assets'] as List<dynamic>;

    for (final asset in assets) {
      if (asset['name'] == ModConstants.modDatabaseAssetName) {
        return asset['browser_download_url'] as String;
      }
    }

    throw StateError(
      '${ModConstants.modDatabaseAssetName} asset not found in release',
    );
  }
}
