import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/domain/entities/release.dart';
import 'package:openra_launcher/domain/repositories/mod_releases_repository.abstract.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/usecases/use_case.abstract.dart';

@lazySingleton
class GetLatestModReleases implements UseCase<Set<Release>, NoParams> {
  final ModReleasesRepository repository;

  GetLatestModReleases(this.repository);

  @override
  Future<Either<Failure, Set<Release>>> call(NoParams params) async {
    var result = await repository.getModReleases();

    if (result.isRight()) {
      return result
          .map((releases) => releases.where((r) => !r.isPlaytest).toSet());
    }

    return result;
  }
}
