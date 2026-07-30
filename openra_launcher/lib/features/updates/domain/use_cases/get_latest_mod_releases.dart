import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/features/updates/domain/repositories/mod_releases_repository.abstract.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';

@lazySingleton
class GetLatestModReleases implements UseCase<Set<Release>, Params> {
  final ModReleasesRepository repository;

  GetLatestModReleases(this.repository);

  @override
  TaskEither<ServerFailure, Set<Release>> call(Params params) {
    return repository.getModReleases(params.mods);
  }
}

class Params extends Equatable {
  final Set<String> mods;

  const Params({required this.mods});

  @override
  List<Object> get props => [mods];
}
