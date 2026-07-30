import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/features/updates/data/data_sources/mod_releases_data_source.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/updates/domain/repositories/mod_releases_repository.abstract.dart';

@LazySingleton(as: ModReleasesRepository)
class ModReleasesRepositoryImpl implements ModReleasesRepository {
  final ModReleasesDataSource dataSource;

  ModReleasesRepositoryImpl({required this.dataSource});

  @override
  TaskEither<ServerFailure, Set<Release>> getModReleases(Set<String> mods) {
    return dataSource.getModReleases(mods);
  }
}
