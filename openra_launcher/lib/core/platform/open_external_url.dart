import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';
import 'package:url_launcher/url_launcher.dart';

@lazySingleton
class OpenExternalUrl implements TaskEitherUseCase<bool, String> {
  @override
  TaskEither<PlatformFailure, bool> call(String url) {
    return TaskEither.tryCatch(() async {
      final parsedUrl = Uri.parse(url);

      if (await canLaunchUrl(parsedUrl)) {
        return launchUrl(parsedUrl, mode: LaunchMode.externalApplication);
      }

      throw 'Could not open "$parsedUrl"';
    }, (onError, stackTrace) => PlatformFailure(onError.toString()));
  }
}
