import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/constants/constants.dart';
import 'package:openra_launcher/core/error/exceptions.dart';
import 'package:openra_launcher/data/models/release_model.dart';
import 'package:openra_launcher/utils/release_utils.dart';

abstract class ModReleasesDataSource {
  /// Queries the GitHub API for releases
  /// and creates models from them.
  ///
  /// Throws a [ServerException] on error.
  Future<Set<ReleaseModel>> getModReleases(Set<String> mods);
}

@LazySingleton(as: ModReleasesDataSource)
class ModReleasesDataSourceImpl implements ModReleasesDataSource {
  final http.Client client;
  static final Map<String, String> endpoints = Constants.modRepos.map((key,
          repoEndpoint) =>
      MapEntry(key, ReleaseUtils.buildGitHubReleasesEndpoint(repoEndpoint)));

  ModReleasesDataSourceImpl({
    required this.client,
  });

  @override
  Future<Set<ReleaseModel>> getModReleases(Set<String> mods) async {
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

        final response = await client.read(Uri.parse(endpoint));

        rawResponses[modId] = response;
        alreadyFetched[endpoint] = response;
      }
    } catch (e) {
      throw ServerException(e.toString());
    } finally {
      client.close();
    }

    Set<ReleaseModel> releases = {};

    rawResponses.forEach((modId, response) {
      releases.addAll(_getReleasesFromResponse(modId, response));
    });

    return Future.value(releases);
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
