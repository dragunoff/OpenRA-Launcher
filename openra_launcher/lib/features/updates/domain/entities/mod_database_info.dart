import 'package:flutter/foundation.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';

@immutable
class ModDatabaseInfo {
  final String modId;
  final String title;
  final String? description;
  final String? homepage;
  final String? repoUrl;
  final Uint8List? icon;
  final Release? stable;
  final Release? playtest;

  const ModDatabaseInfo({
    required this.modId,
    required this.title,
    this.description,
    this.homepage,
    this.repoUrl,
    this.icon,
    this.stable,
    this.playtest,
  });
}
