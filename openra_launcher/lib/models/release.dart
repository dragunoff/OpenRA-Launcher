import 'package:flutter/foundation.dart';

@immutable
class Release {
  final String modId;
  final int id;
  final String title;
  final String version;
  final bool isPlaytest;
  final String htmlUrl;

  const Release(this.modId, this.id, this.title, this.version, this.isPlaytest,
      this.htmlUrl);

  factory Release.fromResponse(
      String modId, Map<String, dynamic> githubRelease) {
    return Release(
        modId,
        githubRelease['id'],
        githubRelease['name'],
        githubRelease['tag_name'],
        githubRelease['prerelease'],
        githubRelease['html_url']);
  }

  @override
  int get hashCode => id.hashCode ^ modId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Release && id == other.id;
}
