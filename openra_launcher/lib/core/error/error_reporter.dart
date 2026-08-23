import 'package:flutter/foundation.dart';

/// Signature used by services to report unexpected errors for diagnostics.
typedef ErrorReporter = void Function(FlutterErrorDetails details);

/// The default reporter used in production; forwards to [FlutterError].
void defaultErrorReporter(FlutterErrorDetails details) {
  FlutterError.reportError(details);
}
