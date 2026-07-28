import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/domain/repositories/installed_mods_repository.abstract.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';

@lazySingleton
class GetInstalledMods implements UseCase<Set<Mod>, NoParams> {
  final InstalledModsRepository repository;

  GetInstalledMods(this.repository);

  @override
  Future<Either<Failure, Set<Mod>>> call(NoParams params) async {
    return await repository.getInstalledMods();
  }
}
