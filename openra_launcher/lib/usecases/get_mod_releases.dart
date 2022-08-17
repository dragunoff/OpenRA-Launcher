import 'package:dartz/dartz.dart';
import 'package:openra_launcher/domain/entities/release.dart';
import 'package:openra_launcher/domain/repositories/mod_releases_repository.abstract.dart';
import 'package:openra_launcher/error/failures.dart';
import 'package:openra_launcher/usecases/use_case.abstract.dart';

class GetModReleases implements UseCase<Set<Release>, NoParams> {
  final ModReleasesRepository repository;

  GetModReleases(this.repository);

  @override
  Future<Either<Failure, Set<Release>>> call(NoParams params) async {
    return await repository.getLatestReleases();
  }
}
