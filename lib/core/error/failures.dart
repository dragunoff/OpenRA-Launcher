abstract class Failure {
  final String? message;
  const Failure([this.message]);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

class PlatformFailure extends Failure {
  const PlatformFailure([super.message]);
}

class FileSystemFailure extends Failure {
  const FileSystemFailure([super.message]);
}

class MiniYamlFormatFailure extends Failure {
  const MiniYamlFormatFailure([super.message]);
}

class GameServerParseFailure extends Failure {
  final Object exception;
  final StackTrace? stackTrace;

  const GameServerParseFailure(
    this.exception, [
    this.stackTrace,
    String? message,
  ]) : super(message);
}

// class UnexpectedFailure extends Failure {
//   final Object exception;
//   final StackTrace? stackTrace;

//   const UnexpectedFailure(this.exception, [this.stackTrace, String? message])
//       : super(message ?? exception.toString());
// }
