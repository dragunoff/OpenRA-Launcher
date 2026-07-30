import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/installed_mods/data/data_sources/installed_mods_data_source.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/domain/repositories/installed_mods_repository.abstract.dart';

@LazySingleton(as: InstalledModsRepository)
class InstalledModsRepositoryImpl implements InstalledModsRepository {
  final InstalledModsDataSource dataSource;

  InstalledModsRepositoryImpl({required this.dataSource});

  @override
  TaskEither<FileSystemFailure, Set<Mod>> getInstalledMods() {
    return dataSource.getInstalledMods();
  }
}
