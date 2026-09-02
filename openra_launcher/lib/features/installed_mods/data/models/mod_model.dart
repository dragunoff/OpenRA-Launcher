import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/utils/mini_yaml_utils.dart';

@immutable
class ModModel extends Mod {
  const ModModel({
    required super.key,
    required super.id,
    required super.version,
    required super.title,
    required super.launchPath,
    required super.launchArgs,
    super.icon,
    super.icon2x,
    super.icon3x,
  });

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
