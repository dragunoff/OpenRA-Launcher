import 'package:flutter/foundation.dart';

@immutable
class AppRelease {
  final int id;
  final String name;
  final String version;
  final String htmlUrl;

  const AppRelease({
    required this.id,
    required this.name,
    required this.version,
    required this.htmlUrl,
  });

  AppRelease copyWith({
    int? id,
    String? version,
    String? name,
    String? htmlUrl,
  }) {
    return AppRelease(
      id: id ?? this.id,
      version: version ?? this.version,
      name: name ?? this.name,
      htmlUrl: htmlUrl ?? this.htmlUrl,
    );
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppRelease && id == other.id;
}
