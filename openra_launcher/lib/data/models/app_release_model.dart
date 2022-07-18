import 'package:flutter/foundation.dart';
import 'package:openra_launcher/domain/entities/app_release.dart';

@immutable
class AppReleaseModel extends AppRelease {
  const AppReleaseModel({
    required int id,
    required String name,
    required String version,
    required String htmlUrl,
  }) : super(id: id, name: name, version: version, htmlUrl: htmlUrl);

  factory AppReleaseModel.fromJson(Map<String, dynamic> githubReleaseJson) {
    return AppReleaseModel(
      id: githubReleaseJson['id'],
      name: githubReleaseJson['name'],
      version: githubReleaseJson['tag_name'],
      htmlUrl: githubReleaseJson['html_url'],
    );
  }
}
