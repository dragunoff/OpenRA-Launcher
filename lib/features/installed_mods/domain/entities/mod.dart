import 'package:flutter/foundation.dart';

enum ModReleaseType { none, release, playtest }

@immutable
class Mod implements Comparable {
  final String key;
  final String id;
  final String version;
  final String title;
  final String launchPath;
  final List<String> launchArgs;
  final Uint8List? icon;
  final Uint8List? icon2x;
  final Uint8List? icon3x;

  const Mod({
    required this.key,
    required this.id,
    required this.version,
    required this.title,
    required this.launchPath,
    required this.launchArgs,
    this.icon,
    this.icon2x,
    this.icon3x,
  });

  Mod copyWith({
    String? key,
    String? id,
    String? version,
    String? title,
    String? launchPath,
    List<String>? launchArgs,
    Uint8List? icon,
    Uint8List? icon2x,
    Uint8List? icon3x,
  }) {
    return Mod(
      key: key ?? this.key,
      id: id ?? this.id,
      version: version ?? this.version,
      title: title ?? this.title,
      launchPath: launchPath ?? this.launchPath,
      launchArgs: launchArgs ?? this.launchArgs,
      icon: icon ?? this.icon,
      icon2x: icon2x ?? this.icon2x,
      icon3x: icon3x ?? this.icon3x,
    );
  }

  @override
  int get hashCode => Object.hash(id, version, title, launchPath);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Mod &&
          id == other.id &&
          version == other.version &&
          title == other.title &&
          launchPath == other.launchPath;

  @override
  int compareTo(other) {
    int result = title.compareTo(other.title);
    result = result == 0 ? other.version.compareTo(version) : result;
    return result;
  }
}
