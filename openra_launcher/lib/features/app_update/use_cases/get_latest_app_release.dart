import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/features/app_update/domain/entities/app_release.dart';
import 'package:openra_launcher/features/app_update/domain/repositories/app_releases_repository.abstract.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';

@lazySingleton
class GetLatestAppRelease implements UseCase<AppRelease, NoParams> {
  final AppReleasesRepository repository;

  GetLatestAppRelease(this.repository);

  @override
  Future<Either<Failure, AppRelease>> call(NoParams params) async {
    return await repository.getLatestRelease();
  }
}
