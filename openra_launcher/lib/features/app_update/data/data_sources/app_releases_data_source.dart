import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/core/network/http_client_service.dart';
import 'package:openra_launcher/features/app_update/data/models/app_release_model.dart';
import 'package:openra_launcher/utils/github_utils.dart';

abstract class AppReleasesDataSource {
  TaskEither<ServerFailure, AppReleaseModel> getLatestRelease();
}

@LazySingleton(as: AppReleasesDataSource)
class AppReleasesDataSourceImpl implements AppReleasesDataSource {
  final endpoint = Uri.parse(
      GitHubUtils.buildLatestReleaseEndpoint('dragunoff/OpenRA-Launcher'));

  final HttpClientService httpClientService;

  AppReleasesDataSourceImpl({
    required this.httpClientService,
  });

  @override
  TaskEither<ServerFailure, AppReleaseModel> getLatestRelease() {
    return TaskEither.tryCatch(() async {
      final rawResponse = await httpClientService.read(endpoint);
      final responseBody = jsonDecode(rawResponse) as Map<String, dynamic>;
      httpClientService.close();

      return AppReleaseModel.fromJson(responseBody);
    }, (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        context: ErrorDescription('fetching latest app release from GitHub'),
      ));

      httpClientService.close();

      return ServerFailure(error.toString());
    });
  }
}
