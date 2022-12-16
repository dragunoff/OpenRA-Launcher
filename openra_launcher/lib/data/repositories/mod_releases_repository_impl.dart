import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/exceptions.dart';
import 'package:openra_launcher/data/data_sources/mod_releases_data_source.dart';
import 'package:openra_launcher/domain/entities/release.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/domain/repositories/mod_releases_repository.abstract.dart';

@LazySingleton(as: ModReleasesRepository)
class ModReleasesRepositoryImpl implements ModReleasesRepository {
  final ModReleasesDataSource dataSource;

  ModReleasesRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Set<Release>>> getModReleases(Set<String> mods) async {
    try {
      return Right(await dataSource.getModReleases(mods));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
