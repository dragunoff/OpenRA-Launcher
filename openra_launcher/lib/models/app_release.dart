import 'package:flutter/foundation.dart';

@immutable
class AppRelease {
  final int id;
  final String title;
  final String version;
  final String htmlUrl;

  const AppRelease(this.id, this.title, this.version, this.htmlUrl);

  factory AppRelease.fromResponse(Map<String, dynamic> githubRelease) {
    return AppRelease(githubRelease['id'], githubRelease['name'],
        githubRelease['tag_name'], githubRelease['html_url']);
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppRelease && id == other.id;
}
