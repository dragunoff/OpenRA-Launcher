import 'package:dartz/dartz.dart';
import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/error/failures.dart';

abstract class InstalledModsRepository {
  Future<Either<Failure, Set<Mod>>> getInstalledMods();
}
