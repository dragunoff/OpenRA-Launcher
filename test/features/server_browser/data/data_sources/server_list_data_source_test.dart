import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/core/network/http_client_service.dart';
import 'package:openra_launcher/features/server_browser/data/data_sources/server_list_data_source.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';

import '../../../../../testing/utils/test_utils.dart';
@GenerateMocks([HttpClientService])
import 'server_list_data_source_test.mocks.dart';

void main() {
  final mockClient = MockHttpClientService();
  ServerListDataSourceImpl dataSource = ServerListDataSourceImpl(
    httpClientService: mockClient,
  );

  final tGamesResponse = TestUtils.getJsonStringFromFile(
    'games_json/servers.json',
  );

  setUp(() {
    dataSource = ServerListDataSourceImpl(httpClientService: mockClient);

    reset(mockClient);
    when(
      mockClient.read(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => tGamesResponse);
  });

  group('ServerListDataSourceImpl', () {
    group('getServerList', () {
      test('should fetch the server list endpoint', () async {
        // when
        await dataSource.getServerList().run();

        // then
        verify(
          mockClient.read(
            ServerListDataSourceImpl.gamesEndpoint,
            headers: anyNamed('headers'),
          ),
        ).called(1);
      });

      test('should parse the server list response', () async {
        // when
        final result = await dataSource.getServerList().run();

        // then
        result.fold((failure) => fail('Expected Either.Right'), (servers) {
          expect(servers, hasLength(3));
          expect(servers.first, isA<GameServer>());
          expect(servers.first.name, 'Red Alert #1');
          expect(servers.first.status, GameServerStatus.waiting);
          expect(servers[1].status, GameServerStatus.playing);
          expect(servers[2].status, GameServerStatus.empty);
          expect(servers.first.clients, hasLength(2));
        });
      });

      test('should throw [ServerFailure] when HTTP client throws', () async {
        // given
        when(
          mockClient.read(any, headers: anyNamed('headers')),
        ).thenThrow(http.ClientException('reason'));

        // when
        final result = await dataSource.getServerList().run();

        // then
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (result) => fail('Expected Either.Left'),
        );
      });

      test('should return an empty list for an empty response', () async {
        // given
        when(
          mockClient.read(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => '[]');

        // when
        final result = await dataSource.getServerList().run();

        // then
        result.fold(
          (failure) => fail('Expected Either.Right'),
          (result) => expect(result, isEmpty),
        );
      });
    });
  });
}
