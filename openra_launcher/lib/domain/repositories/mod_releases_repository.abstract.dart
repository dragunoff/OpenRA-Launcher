import 'package:dartz/dartz.dart';
import 'package:openra_launcher/domain/entities/release.dart';
import 'package:openra_launcher/core/error/failures.dart';

abstract class ModReleasesRepository {
  Future<Either<Failure, Set<Release>>> getModReleases();
}
