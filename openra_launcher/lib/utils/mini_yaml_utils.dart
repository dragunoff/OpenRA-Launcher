import 'dart:io';

class MiniYamlUtils {
  static Map<String, String> modMetadataFromFile(File file) {
    var metadata = _getFieldsMapFromFile(file);
    var mandatoryFields = [
      'Id',
      'Version',
      'Title',
      'LaunchPath',
      'LaunchArgs'
    ];

    for (var field in mandatoryFields) {
      if (!metadata.containsKey(field)) {
        throw Exception(
            'Invalid metadata file: "$file". Mandatory field "$field" is missing.');
      }

      if (metadata[field] == '') {
        throw Exception(
            'Invalid metadata file: "$file". Field "$field" is empty.');
      }
    }

    return metadata;
  }

  static Map<String, String> _getFieldsMapFromFile(File file) {
    var metadata = <String, String>{};
    var lines = file.readAsLinesSync().map((line) => line.trim()).toList();

    for (var line in lines) {
      var split = line.split(':');
      if (split.length == 2) {
        metadata[split[0].trim()] = split[1].trim();
      }
    }

    return metadata;
  }
}
