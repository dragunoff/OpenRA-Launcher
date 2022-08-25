import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/utils/mini_yaml_utils.dart';

@immutable
class ModModel extends Mod {
  const ModModel({
    required String key,
    required String id,
    required String version,
    required String title,
    required String launchPath,
    required List<String> launchArgs,
    Uint8List? icon,
    Uint8List? icon2x,
    Uint8List? icon3x,
    bool isRelease = false,
    bool isPlaytest = false,
    bool hasRelease = false,
    bool hasPlaytest = false,
  }) : super(
          key: key,
          id: id,
          version: version,
          title: title,
          launchPath: launchPath,
          launchArgs: launchArgs,
          icon: icon,
          icon2x: icon2x,
          icon3x: icon3x,
          isRelease: isRelease,
          isPlaytest: isPlaytest,
          hasRelease: hasRelease,
          hasPlaytest: hasPlaytest,
        );

  factory ModModel.fromFile(File file) {
    final metadata = MiniYamlUtils.modMetadataFromFile(file);

    final id = metadata['Id'] as String;
    final version = metadata['Version'] as String;
    final title = metadata['Title'] as String;
    final launchPath = metadata['LaunchPath'] as String;
    final launchArgs = metadata['LaunchArgs']?.split(', ') as List<String>;
    final key = '$id-$version';
    final icon = metadata['Icon'] != null
        ? const Base64Decoder().convert(metadata['Icon'] as String)
        : null;
    final icon2x = metadata['Icon2x'] != null
        ? const Base64Decoder().convert(metadata['Icon3x'] as String)
        : null;
    final icon3x = metadata['Icon3x'] != null
        ? const Base64Decoder().convert(metadata['Icon3x'] as String)
        : null;

    return ModModel(
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
}
