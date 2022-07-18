import 'package:flutter/foundation.dart';

@immutable
class Release {
  final String modId;
  final int id;
  final String name;
  final String version;
  final bool isPlaytest;
  final String htmlUrl;

  const Release({
    required this.modId,
    required this.id,
    required this.name,
    required this.version,
    required this.isPlaytest,
    required this.htmlUrl,
  });

  Release copyWith({
    String? modId,
    int? id,
    String? version,
    String? name,
    String? htmlUrl,
    bool? isPlaytest,
  }) {
    return Release(
      modId: modId ?? this.modId,
      id: id ?? this.id,
      version: version ?? this.version,
      name: name ?? this.name,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      isPlaytest: isPlaytest ?? this.isPlaytest,
    );
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Release && id == other.id;
}
