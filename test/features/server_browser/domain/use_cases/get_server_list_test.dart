import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/features/server_browser/domain/repositories/server_list_repository.abstract.dart';
import 'package:openra_launcher/features/server_browser/domain/use_cases/get_server_list.dart';

@GenerateMocks([ServerListRepository])
import 'get_server_list_test.mocks.dart';

void main() {
  provideDummy<TaskEither<ServerFailure, List<GameServer>>>(
    TaskEither.left(const ServerFailure()),
  );

  MockServerListRepository mockRepository = MockServerListRepository();
  GetServerList usecase = GetServerList(mockRepository);

  final tServers = <GameServer>[];

  setUp(() {
    mockRepository = MockServerListRepository();
    usecase = GetServerList(mockRepository);
  });

  group('GetServerList', () {
    test('should get the server list from the repository', () async {
      // given
      when(
        mockRepository.getServerList(),
      ).thenAnswer((_) => TaskEither.right(tServers));

      // when
      final response = await usecase(NoParams()).run();

      // then
      expect(response, Right(tServers));
      verify(mockRepository.getServerList());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
