import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/error_reporter.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';
import 'package:url_launcher/url_launcher.dart';

@lazySingleton
class OpenExternalUrl implements TaskEitherUseCase<bool, String> {
  final ErrorReporter reportError;

  OpenExternalUrl({this.reportError = defaultErrorReporter});

  @override
  TaskEither<PlatformFailure, bool> call(String url) {
    return TaskEither.tryCatch(
      () async {
        final parsedUrl = Uri.parse(url);

        if (await canLaunchUrl(parsedUrl)) {
          return launchUrl(parsedUrl, mode: LaunchMode.externalApplication);
        }

        throw 'Could not open "$parsedUrl"';
      },
      (error, stackTrace) {
        reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'core',
            context: ErrorDescription('opening external URL'),
          ),
        );

        return PlatformFailure(error.toString());
      },
    );
  }
}
