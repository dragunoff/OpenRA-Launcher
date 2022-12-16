import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/domain/entities/release.dart';
import 'package:openra_launcher/domain/repositories/mod_releases_repository.abstract.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/usecases/use_case.abstract.dart';

@lazySingleton
class GetLatestModReleases implements UseCase<Set<Release>, Params> {
  final ModReleasesRepository repository;

  GetLatestModReleases(this.repository);

  @override
  Future<Either<Failure, Set<Release>>> call(Params params) async {
    return await repository.getModReleases(params.mods);
  }
}

class Params extends Equatable {
  final Set<String> mods;

  const Params({required this.mods});

  @override
  List<Object> get props => [mods];
}
