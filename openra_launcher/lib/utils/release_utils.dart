import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:openra_launcher/constants/constants.dart';
import 'package:openra_launcher/data/models/release_model.dart';
import 'package:openra_launcher/domain/entities/release.dart';
import 'package:openra_launcher/core/error/exceptions.dart';
import 'package:openra_launcher/utils/mod_utils.dart';

class ReleaseUtils {
  static final Map<String, String> _endpoints = Constants.modRepos.map(
      (key, repoEndpoint) =>
          MapEntry(key, _buildGitHubReleasesEndpoint(repoEndpoint)));

  static Future<http.Response> fetchLatestAppRelease() {
    try {
      return http
          .get(Uri.parse(_buildGitHubLatestReleaseEndpoint(Constants.appRepo)));
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Set<Release>> fetchLatestReleases(Set<String> mods) async {
    final client = http.Client();
    Map<String, http.Response> rawResponses = {};

    Set<String> endpointIdsToFetch = mods.fold({}, (previousValue, modId) {
      if (!ModUtils.isSupportedForUpdates(modId)) {
        return previousValue;
      }

      final modIdToAdd =
          Constants.officialModIds.contains(modId) ? 'openra' : modId;

      return previousValue..add(modIdToAdd);
    });

    try {
      for (final modId in _endpoints.keys
          .where((endpointId) => endpointIdsToFetch.contains(endpointId))) {
        final response =
            await client.get(Uri.parse(_endpoints[modId] as String));

        if ((response.statusCode < 200) ||
            (response.statusCode >= 300 && response.statusCode < 400)) {
          continue;
        } else if (response.statusCode >= 400) {
          throw ServerException(
              'Error while fetching mod updates (${response.statusCode} ${response.reasonPhrase})');
        }

        rawResponses[modId] = response;
      }
    } catch (e) {
      return Future.error(e);
    } finally {
      client.close();
    }

    Set<Release> releases = {};

    rawResponses.forEach((modId, response) {
      releases.addAll(ReleaseUtils.getReleasesFromResponse(modId, response));
    });

    return releases;
  }

  static Set<Release> getLatestReleaseForMod(
      String modId, Set<Release> releases) {
    return releases
        .where((release) => release.modId == modId)
        .where((release) => !release.isPlaytest)
        .toSet();
  }

  static Set<Release> getLatestPlaytestForMod(
      String modId, Set<Release> releases) {
    return releases
        .where((release) => release.modId == modId)
        .where((release) => release.isPlaytest)
        .toSet();
  }

  static Set<String> getSupportedMods() {
    Set<String> supported = Set.from(Constants.modRepos.keys);

    if (supported.contains('openra')) {
      supported
        ..remove('openra')
        ..addAll(Constants.officialModIds);
    }

    return supported;
  }

  static Set<Release> getReleasesFromResponse(
      String modId, http.Response response) {
    Set<Release> releases = {};

    var decodedResponse = jsonDecode(response.body) as List;

    decodedResponse =
        decodedResponse.where((element) => element['draft'] == false).toList();

    if (decodedResponse.isEmpty) {
      return {};
    }

    final latestRelease = decodedResponse.firstWhere(
        (element) => element['prerelease'] == false,
        orElse: () => null);

    if (latestRelease != null) {
      if (modId == 'openra') {
        for (final officialModId in Constants.officialModIds) {
          releases.add(ReleaseModel.fromJson(officialModId, latestRelease));
        }
      } else {
        releases.add(ReleaseModel.fromJson(modId, latestRelease));
      }
    }

    if (decodedResponse.first['prerelease'] == true) {
      final latestPlaytest = decodedResponse.first;

      if (modId == 'openra') {
        for (final officialModId in Constants.officialModIds) {
          releases.add(ReleaseModel.fromJson(officialModId, latestRelease));
        }
      } else {
        releases.add(ReleaseModel.fromJson(modId, latestPlaytest));
      }
    }

    return releases;
  }

  static String _buildGitHubReleasesEndpoint(String repoEndpoint) {
    return Constants.githubApiUrl +
        Constants.githubReposEndpoint +
        repoEndpoint +
        Constants.githubReleasesEndpoint;
  }

  static String _buildGitHubLatestReleaseEndpoint(String repoEndpoint) {
    return '${_buildGitHubReleasesEndpoint(repoEndpoint)}/latest';
  }
}
