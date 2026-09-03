import 'package:flutter/foundation.dart';

@immutable
class Release {
  final String modId;
  final int id;
  final String name;
  final String version;
  final bool isPlaytest;
  final String htmlUrl;
  final String? body;

  const Release({
    required this.modId,
    required this.id,
    required this.name,
    required this.version,
    required this.isPlaytest,
    required this.htmlUrl,
    this.body,
  });

  bool get hasReleaseNotes =>
      name.trim().isNotEmpty || (body?.trim().isNotEmpty ?? false);

  bool get hasBody => body?.trim().isNotEmpty ?? false;

  Release copyWith({
    String? modId,
    int? id,
    String? version,
    String? name,
    String? htmlUrl,
    bool? isPlaytest,
    String? body,
  }) {
    return Release(
      modId: modId ?? this.modId,
      id: id ?? this.id,
      version: version ?? this.version,
      name: name ?? this.name,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      isPlaytest: isPlaytest ?? this.isPlaytest,
      body: body ?? this.body,
    );
  }

  @override
  int get hashCode => Object.hash(id, version, modId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Release &&
          id == other.id &&
          version == other.version &&
          modId == other.modId;
}
