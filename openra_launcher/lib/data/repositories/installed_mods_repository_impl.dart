import 'package:dartz/dartz.dart';
import 'package:openra_launcher/core/error/exceptions.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/data/data_sources/installed_mods_data_source.abstract.dart';
import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/domain/repositories/installed_mods_repository.abstract.dart';

class InstalledModsRepositoryImpl implements InstalledModsRepository {
  final InstalledModsDataSource dataSource;

  InstalledModsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Set<Mod>>> getInstalledMods() async {
    try {
      return Right(await dataSource.getInstalledMods());
    } on FileSystemException {
      return Left(FileSystemFailure());
    }
  }
}
