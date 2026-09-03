import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database.dart';
import 'package:openra_launcher/features/updates/domain/repositories/mod_database_repository.abstract.dart';

@lazySingleton
class GetModDatabase implements TaskEitherUseCase<ModDatabase, NoParams> {
  final ModDatabaseRepository repository;

  GetModDatabase(this.repository);

  @override
  TaskEither<ServerFailure, ModDatabase> call(NoParams params) {
    return repository.getModDatabase();
  }
}
