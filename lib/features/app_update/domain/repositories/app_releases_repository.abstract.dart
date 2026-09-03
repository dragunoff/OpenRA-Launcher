import 'package:fpdart/fpdart.dart';
import 'package:openra_launcher/features/app_update/domain/entities/app_release.dart';
import 'package:openra_launcher/core/error/failures.dart';

abstract class AppReleasesRepository {
  TaskEither<Failure, AppRelease> getLatestRelease();
}
