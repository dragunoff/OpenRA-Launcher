import 'package:flutter/foundation.dart';
import 'package:openra_launcher/domain/entities/release.dart';

@immutable
class ReleaseModel extends Release {
  const ReleaseModel({
    required modId,
    required id,
    required name,
    required version,
    required isPlaytest,
    required htmlUrl,
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
