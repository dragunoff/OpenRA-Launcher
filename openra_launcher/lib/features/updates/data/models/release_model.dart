import 'package:flutter/foundation.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';

@immutable
class ReleaseModel extends Release {
  const ReleaseModel({
    required String modId,
    required int id,
    required String name,
    required String version,
    required bool isPlaytest,
    required String htmlUrl,
  }) : super(
          modId: modId,
          id: id,
          name: name,
          version: version,
          isPlaytest: isPlaytest,
          htmlUrl: htmlUrl,
        );

  factory ReleaseModel.fromJson(
    String modId,
    Map<String, dynamic> githubReleaseJson,
  ) {
    return ReleaseModel(
      modId: modId,
      id: githubReleaseJson['id'],
      name: githubReleaseJson['name'],
      version: githubReleaseJson['tag_name'],
      isPlaytest: githubReleaseJson['prerelease'],
      htmlUrl: githubReleaseJson['html_url'],
    );
  }
}
