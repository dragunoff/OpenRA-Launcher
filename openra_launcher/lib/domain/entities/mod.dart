import 'dart:typed_data';

import 'package:flutter/foundation.dart';

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
  final bool isRelease;
  final bool isPlaytest;
  final bool hasRelease;
  final bool hasPlaytest;

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
    this.isRelease = false,
    this.isPlaytest = false,
    this.hasRelease = false,
    this.hasPlaytest = false,
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
    bool? isRelease,
    bool? isPlaytest,
    bool? hasRelease,
    bool? hasPlaytest,
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
      isRelease: isRelease ?? this.isRelease,
      isPlaytest: isPlaytest ?? this.isPlaytest,
      hasRelease: hasRelease ?? this.hasRelease,
      hasPlaytest: hasPlaytest ?? this.hasPlaytest,
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
