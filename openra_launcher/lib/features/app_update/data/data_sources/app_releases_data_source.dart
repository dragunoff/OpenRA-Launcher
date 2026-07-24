import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/exceptions.dart';
import 'package:openra_launcher/core/network/http_client_service.dart';
import 'package:openra_launcher/features/app_update/data/models/app_release_model.dart';
import 'package:openra_launcher/utils/github_utils.dart';

abstract class AppReleasesDataSource {
  /// Queries the GitHub API for releases
  /// and creates models from them.
  ///
  /// Throws a [ServerException] on error.
  Future<AppReleaseModel> getLatestRelease();
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
  Future<AppReleaseModel> getLatestRelease() async {
    try {
      final rawResponse = await httpClientService.read(endpoint);
      final responseBody = jsonDecode(rawResponse) as Map<String, dynamic>;

      return AppReleaseModel.fromJson(responseBody);
    } catch (e) {
      throw ServerException(e.toString());
    } finally {
      httpClientService.close();
    }
  }
}
