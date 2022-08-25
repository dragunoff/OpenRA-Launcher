class ServerException implements Exception {
  final String message;

  const ServerException([this.message = ""]);
}

class FileSystemException implements Exception {}

class MiniYamlFormatException implements Exception {
  final String message;

  const MiniYamlFormatException([this.message = ""]);
}
