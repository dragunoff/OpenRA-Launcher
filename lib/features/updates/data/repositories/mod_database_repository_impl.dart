import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/updates/data/data_sources/mod_database_data_source.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database.dart';
import 'package:openra_launcher/features/updates/domain/repositories/mod_database_repository.abstract.dart';

@LazySingleton(as: ModDatabaseRepository)
class ModDatabaseRepositoryImpl implements ModDatabaseRepository {
  final ModDatabaseDataSource dataSource;

  ModDatabaseRepositoryImpl({required this.dataSource});

  @override
  TaskEither<ServerFailure, ModDatabase> getModDatabase() {
    return dataSource.getModDatabase();
  }
}
