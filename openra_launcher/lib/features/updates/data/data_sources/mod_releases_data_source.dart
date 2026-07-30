import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/constants/mod_constants.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/core/network/http_client_service.dart';
import 'package:openra_launcher/features/updates/data/models/release_model.dart';
import 'package:openra_launcher/utils/github_utils.dart';

abstract class ModReleasesDataSource {
  TaskEither<ServerFailure, Set<ReleaseModel>> getModReleases(Set<String> mods);
}

@LazySingleton(as: ModReleasesDataSource)
class ModReleasesDataSourceImpl implements ModReleasesDataSource {
  final HttpClientService httpClientService;
  static final Map<String, String> endpoints = ModConstants.modRepos.map(
      (key, repoEndpoint) =>
          MapEntry(key, GitHubUtils.buildReleasesEndpoint(repoEndpoint)));

  ModReleasesDataSourceImpl({
    required this.httpClientService,
  });

  @override
  TaskEither<ServerFailure, Set<ReleaseModel>> getModReleases(
      Set<String> mods) {
    return TaskEither.tryCatch(() async {
      Map<String, String> rawResponses = {};
      Map<String, String> alreadyFetched = {};
      final endpointsToFetch = Map.from(endpoints);
      endpointsToFetch.removeWhere((key, value) => !mods.contains(key));

      try {
        for (final modId in endpointsToFetch.keys) {
          final endpoint = endpointsToFetch[modId];

          if (alreadyFetched.containsKey(endpoint)) {
            rawResponses[modId] = alreadyFetched[endpoint] as String;
            continue;
          }

          final response = await httpClientService.read(Uri.parse(endpoint));

          rawResponses[modId] = response;
          alreadyFetched[endpoint] = response;
        }
      } finally {
        httpClientService.close();
      }

      Set<ReleaseModel> releases = {};

      rawResponses.forEach((modId, response) {
        releases.addAll(_getReleasesFromResponse(modId, response));
      });

      return Future.value(releases);
    }, (error, stackTrace) => ServerFailure(error.toString()));
  }

  static Set<ReleaseModel> _getReleasesFromResponse(
      String modId, String response) {
    Set<ReleaseModel> releases = {};

    var decodedResponse = jsonDecode(response) as List;

    decodedResponse =
        decodedResponse.where((element) => element['draft'] == false).toList();

    if (decodedResponse.isEmpty) {
      return {};
    }

    final latestRelease = decodedResponse.firstWhere(
        (element) => element['prerelease'] == false,
        orElse: () => null);

    if (latestRelease != null) {
      releases.add(ReleaseModel.fromJson(modId, latestRelease));
    }

    if (decodedResponse.first['prerelease'] == true) {
      final latestPlaytest = decodedResponse.first;
      releases.add(ReleaseModel.fromJson(modId, latestPlaytest));
    }

    return releases;
  }
}
