import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/features/app_update/domain/entities/app_release.dart';
import 'package:openra_launcher/features/app_update/domain/repositories/app_releases_repository.abstract.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';

@lazySingleton
class GetLatestAppRelease implements TaskEitherUseCase<AppRelease, NoParams> {
  final AppReleasesRepository repository;

  GetLatestAppRelease(this.repository);

  @override
  TaskEither<Failure, AppRelease> call(NoParams params) {
    return repository.getLatestRelease();
  }
}
