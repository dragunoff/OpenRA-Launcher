import 'package:fpdart/fpdart.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database.dart';

abstract class ModDatabaseRepository {
  TaskEither<ServerFailure, ModDatabase> getModDatabase();
}
