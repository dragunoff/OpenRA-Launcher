import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/features/server_browser/domain/repositories/server_list_repository.abstract.dart';

@lazySingleton
class GetServerList implements TaskEitherUseCase<List<GameServer>, NoParams> {
  final ServerListRepository repository;

  GetServerList(this.repository);

  @override
  TaskEither<ServerFailure, List<GameServer>> call(NoParams params) {
    return repository.getServerList();
  }
}
