import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:openra_launcher/utils/mini_yaml_utils.dart';

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

  factory Mod.fromFile(File file) {
    var metadata = MiniYamlUtils.modMetadataFromFile(file);

    var id = metadata['Id'] as String;
    var version = metadata['Version'] as String;
    var title = metadata['Title'] as String;
    var launchPath = metadata['LaunchPath'] as String;
    var launchArgs = metadata['LaunchArgs']?.split(', ') as List<String>;
    var key = '$id-$version';
    var icon = metadata['Icon'] != null
        ? const Base64Decoder().convert(metadata['Icon'] as String)
        : null;
    var icon2x = metadata['Icon2x'] != null
        ? const Base64Decoder().convert(metadata['Icon3x'] as String)
        : null;
    var icon3x = metadata['Icon3x'] != null
        ? const Base64Decoder().convert(metadata['Icon3x'] as String)
        : null;

    return Mod(
      key: key,
      id: id,
      version: version,
      title: title,
      launchPath: launchPath,
      launchArgs: launchArgs,
      icon: icon,
      icon2x: icon2x,
      icon3x: icon3x,
    );
  }

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
