import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/exceptions.dart';
import 'package:openra_launcher/features/app_update/data/data_sources/app_releases_data_source.dart';
import 'package:openra_launcher/features/app_update/domain/entities/app_release.dart';
import 'package:openra_launcher/features/app_update/domain/repositories/app_releases_repository.abstract.dart';
import 'package:openra_launcher/core/error/failures.dart';

@LazySingleton(as: AppReleasesRepository)
class AppReleasesRepositoryImpl implements AppReleasesRepository {
  final AppReleasesDataSource dataSource;

  AppReleasesRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, AppRelease>> getLatestRelease() async {
    try {
      return Right(await dataSource.getLatestRelease());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
