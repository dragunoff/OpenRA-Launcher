import 'package:dartz/dartz.dart';
import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/domain/repositories/installed_mods_repository.abstract.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/usecases/use_case.abstract.dart';

class GetInstalledMods implements UseCase<Set<Mod>, NoParams> {
  final InstalledModsRepository repository;

  GetInstalledMods(this.repository);

  @override
  Future<Either<Failure, Set<Mod>>> call(NoParams params) async {
    return await repository.getInstalledMods();
  }
}
