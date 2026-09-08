import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/server_browser/data/data_sources/server_list_data_source.dart';
import 'package:openra_launcher/features/server_browser/data/repositories/server_list_repository_impl.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';

@GenerateMocks([ServerListDataSource])
import 'server_list_repository_impl_test.mocks.dart';

void main() {
  provideDummy<TaskEither<ServerFailure, List<GameServer>>>(
    TaskEither.left(const ServerFailure()),
  );
  MockServerListDataSource mockDataSource = MockServerListDataSource();
  ServerListRepositoryImpl repository = ServerListRepositoryImpl(
    dataSource: mockDataSource,
  );

  setUp(() {
    reset(mockDataSource);
  });

  group('ServerListRepositoryImpl', () {
    group('getServerList', () {
      final tServers = <GameServer>[];

      test('should get the server list from the data source', () async {
        // given
        when(
          mockDataSource.getServerList(),
        ).thenAnswer((_) => TaskEither.right(tServers));

        // when
        final result = await repository.getServerList().run();

        // then
        verify(mockDataSource.getServerList());
        expect(result, Right(tServers));
      });

      test('should return a failure when an exception is thrown', () async {
        // given
        when(
          mockDataSource.getServerList(),
        ).thenAnswer((_) => TaskEither.left(const ServerFailure()));

        // when
        final result = await repository.getServerList().run();

        // then
        verify(mockDataSource.getServerList());
        result.match(
          (left) => expect(left, isA<ServerFailure>()),
          (_) => fail('Expected Either.Left'),
        );
      });
    });
  });
}
