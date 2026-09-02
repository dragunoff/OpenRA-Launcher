import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database_info.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';

@immutable
class ModDatabaseInfoModel extends ModDatabaseInfo {
  const ModDatabaseInfoModel({
    required super.modId,
    required super.title,
    super.description,
    super.homepage,
    super.repoUrl,
    super.icon,
    super.stable,
    super.playtest,
  });

  factory ModDatabaseInfoModel.fromJson(
    String modId,
    Map<String, dynamic> json,
  ) {
    return ModDatabaseInfoModel(
      modId: modId,
      title: json['title'] ?? '',
      description: json['description'],
      homepage: json['homepage'],
      repoUrl: json['repo_url'],
      icon: _decodeDataUriIcon(json['icon']),
      stable: _releaseFromJson(modId, json['stable']),
      playtest: _releaseFromJson(modId, json['playtest']),
    );
  }

  static Uint8List? _decodeDataUriIcon(dynamic icon) {
    if (icon is! String || icon.isEmpty || !icon.contains(',')) {
      return null;
    }

    final base64Data = icon.split(',').last;
    return base64Decode(base64Data);
  }

  static Release? _releaseFromJson(String modId, dynamic value) {
    if (value is! Map<String, dynamic>) {
      return null;
    }

    return Release(
      modId: modId,
      id: value['id'],
      name: value['name'] ?? '',
      version: value['tag_name'],
      isPlaytest: value['prerelease'] ?? false,
      htmlUrl: value['html_url'],
      body: value['body'],
    );
  }
}
