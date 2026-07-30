import 'package:fpdart/fpdart.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/core/error/failures.dart';

abstract class ModReleasesRepository {
  TaskEither<ServerFailure, Set<Release>> getModReleases(Set<String> mods);
}
