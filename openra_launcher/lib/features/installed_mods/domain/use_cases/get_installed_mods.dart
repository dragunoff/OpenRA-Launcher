import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/domain/repositories/installed_mods_repository.abstract.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';

@lazySingleton
class GetInstalledMods implements TaskEitherUseCase<Set<Mod>, NoParams> {
  final InstalledModsRepository repository;

  GetInstalledMods(this.repository);

  @override
  TaskEither<FileSystemFailure, Set<Mod>> call(NoParams params) {
    return repository.getInstalledMods();
  }
}
