import 'package:flutter/foundation.dart';
import 'package:openra_launcher/features/app_update/domain/entities/app_release.dart';

@immutable
class AppReleaseModel extends AppRelease {
  const AppReleaseModel({
    required super.id,
    required super.name,
    required super.version,
    required super.htmlUrl,
  });

  factory AppReleaseModel.fromJson(Map<String, dynamic> githubReleaseJson) {
    return AppReleaseModel(
      id: githubReleaseJson['id'],
      name: githubReleaseJson['name'],
      version: githubReleaseJson['tag_name'],
      htmlUrl: githubReleaseJson['html_url'],
    );
  }
}
