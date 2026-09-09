import 'dart:convert';

import 'package:flutter/foundation.dart';
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

  final reportedDetails = <FlutterErrorDetails>[];
  ServerListDataSourceImpl reportingDataSource() => ServerListDataSourceImpl(
    httpClientService: mockClient,
    reportError: reportedDetails.add,
  );

  final tGamesResponse = TestUtils.getJsonStringFromFile(
    'games_json/servers.json',
  );

  setUp(() {
    dataSource = ServerListDataSourceImpl(httpClientService: mockClient);
    reportedDetails.clear();

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

      test(
        'should parse a playing server with a string started timestamp',
        () async {
          // given
          when(mockClient.read(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => jsonEncode([
              {
                'id': 1,
                'name': 'Match',
                'address': '127.0.0.1:6243',
                'state': 2,
                'ttl': 42,
                'mod': 'ra',
                'version': 'release-20210321',
                'map': 'map-hash',
                'players': 4,
                'maxplayers': 6,
                'bots': 0,
                'spectators': 0,
                'protected': false,
                'authentication': false,
                'started': '2026-01-06 12:00:00',
                'playtime': 1200,
              },
            ]),
          );

          // when
          final result = await dataSource.getServerList().run();

          // then
          result.fold((failure) => fail('Expected Either.Right'), (servers) {
            expect(servers, hasLength(1));
            expect(servers.first.started, '2026-01-06 12:00:00');
            expect(servers.first.playtime, 1200);
            expect(servers.first.status, GameServerStatus.playing);
          });
        },
      );

      test('should report and skip invalid games advertised', () async {
        // given
        when(mockClient.read(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => jsonEncode([
            {'id': 'not-an-int'},
            {
              'id': 2,
              'name': 'Valid Game',
              'address': '127.0.0.1:6243',
              'state': 1,
              'ttl': 42,
              'mod': 'ra',
              'version': 'release-20210321',
              'map': 'map-hash',
              'players': 1,
              'maxplayers': 8,
              'bots': 0,
              'spectators': 0,
              'protected': false,
              'authentication': false,
            },
          ]),
        );
        final reportingSource = reportingDataSource();

        // when
        final result = await reportingSource.getServerList().run();

        // then
        result.fold((failure) => fail('Expected Either.Right'), (servers) {
          expect(servers, hasLength(1));
          expect(servers.single.name, 'Valid Game');
        });
        expect(reportedDetails, hasLength(1));
        expect(reportedDetails.single.exception, isA<TypeError>());
      });
    });
  });
}
