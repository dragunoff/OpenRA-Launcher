import 'package:dartz/dartz.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/domain/entities/mod.dart';

abstract class InstalledModsRepository {
  Future<Either<Failure, Set<Mod>>> getInstalledMods();
}
