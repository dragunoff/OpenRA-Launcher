import 'dart:io';

import 'package:openra_launcher/core/error/exceptions.dart';

class MiniYamlUtils {
  static Map<String, String> modMetadataFromFile(File file) {
    final metadata = _getFieldsMapFromFile(file);
    final mandatoryFields = [
      'Id',
      'Version',
      'Title',
      'LaunchPath',
      'LaunchArgs'
    ];

    for (final field in mandatoryFields) {
      if (!metadata.containsKey(field)) {
        throw MiniYamlFormatException(
            'Invalid metadata file: "$file". Mandatory field "$field" is missing.');
      }

      if (metadata[field] == '') {
        throw MiniYamlFormatException(
            'Invalid metadata file: "$file". Field "$field" is empty.');
      }
    }

    // NOTE: Explicitly invalidate paths to OpenRA.dll to clean up bogus metadata files
    // that were created after the initial migration from .NET Framework to Core/5
    if (metadata.containsKey('LaunchPath') &&
        metadata['LaunchPath']!.endsWith('.dll')) {
      throw MiniYamlFormatException(
          'Invalid metadata file: "$file". Field "LaunchPath" is invalid because it points to a DLL.');
    }

    return metadata;
  }

  static Map<String, String> _getFieldsMapFromFile(File file) {
    final metadata = <String, String>{};
    final lines = file.readAsLinesSync().map((line) => line.trim()).toList();

    for (final line in lines) {
      final split = line.split(':');
      if (split.length == 2) {
        metadata[split[0].trim()] = split[1].trim();
      }
    }

    return metadata;
  }
}
