import 'package:fpdart/fpdart.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';

abstract class InstalledModsRepository {
  TaskEither<FileSystemFailure, Set<Mod>> getInstalledMods();
}
