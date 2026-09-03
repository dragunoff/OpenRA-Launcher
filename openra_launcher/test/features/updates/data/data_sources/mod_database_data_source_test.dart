import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/constants/mod_constants.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/core/network/http_client_service.dart';
import 'package:openra_launcher/features/updates/data/data_sources/mod_database_data_source.dart';
import 'package:openra_launcher/utils/github_utils.dart';

import '../../../../../testing/utils/test_utils.dart';
@GenerateMocks([HttpClientService])
import 'mod_database_data_source_test.mocks.dart';

void main() {
  final mockClient = MockHttpClientService();
  ModDatabaseDataSourceImpl dataSource = ModDatabaseDataSourceImpl(
    httpClientService: mockClient,
  );

  final tReleaseResponse = TestUtils.getJsonStringFromFile(
    'github_json/mod-database-release.json',
  );
  final tDatabaseResponse = TestUtils.getJsonStringFromFile(
    'github_json/mod-database.json',
  );

  final tAssetUrl =
      'https://github.com/dragunoff/OpenRA-Mod-Database/releases/download/database-2026-01-01/OpenRA-Mod-Database.json';
  final tReleaseEndpoint = Uri.parse(
    GitHubUtils.buildLatestReleaseEndpoint(ModConstants.modDatabaseRepo),
  );

  setUp(() {
    dataSource = ModDatabaseDataSourceImpl(httpClientService: mockClient);

    reset(mockClient);
    when(
      mockClient.read(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => tDatabaseResponse);
  });

  group('ModDatabaseDataSourceImpl', () {
    group('getModDatabase', () {
      test(
        'should fetch the release endpoint and the database asset',
        () async {
          // given
          when(
            mockClient.read(tReleaseEndpoint, headers: anyNamed('headers')),
          ).thenAnswer((_) async => tReleaseResponse);

          // when
          await dataSource.getModDatabase().run();

          // then
          verify(
            mockClient.read(tReleaseEndpoint, headers: anyNamed('headers')),
          ).called(1);
          verify(
            mockClient.read(Uri.parse(tAssetUrl), headers: anyNamed('headers')),
          ).called(1);
        },
      );

      test('should throw [ServerFailure] when HTTP client throws', () async {
        // given
        when(
          mockClient.read(tReleaseEndpoint, headers: anyNamed('headers')),
        ).thenThrow(http.ClientException('reason'));

        // when
        final result = await dataSource.getModDatabase().run();

        // then
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (result) => fail('Expected Either.Left'),
        );
      });

      test(
        'should return a ServerFailure when database asset is missing',
        () async {
          // given
          const releaseWithoutAsset = '{"id": 1, "assets": []}';
          when(
            mockClient.read(tReleaseEndpoint, headers: anyNamed('headers')),
          ).thenAnswer((_) async => releaseWithoutAsset);

          // when
          final result = await dataSource.getModDatabase().run();

          // then
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (result) => fail('Expected Either.Left'),
          );
        },
      );

      test(
        'should return an empty database when the database is empty',
        () async {
          // given
          when(
            mockClient.read(tReleaseEndpoint, headers: anyNamed('headers')),
          ).thenAnswer((_) async => tReleaseResponse);
          when(
            mockClient.read(Uri.parse(tAssetUrl), headers: anyNamed('headers')),
          ).thenAnswer((_) async => '{}');

          // when
          final result = await dataSource.getModDatabase().run();

          // then
          result.fold(
            (failure) => fail('Expected Either.Right'),
            (result) => expect(result.mods, isEmpty),
          );
        },
      );

      test('should parse per-mod metadata and stable/playtest releases from '
          'the database', () async {
        // given
        when(
          mockClient.read(tReleaseEndpoint, headers: anyNamed('headers')),
        ).thenAnswer((_) async => tReleaseResponse);

        // when
        final result = await dataSource.getModDatabase().run();

        // then
        result.fold((failure) => fail('Expected Either.Right'), (result) {
          expect(result.mods.keys, containsAll(['ca', 'cnc', 'd2', 'ta']));

          final ca = result.mods['ca'];
          expect(ca?.title, isNotEmpty);
          expect(ca?.description, isNotNull);
          expect(ca?.homepage, isNotNull);
          expect(ca?.repoUrl, isNotNull);
          expect(ca?.stable, isNotNull);
          expect(ca?.playtest, isNotNull);
          expect(ca?.stable?.modId, 'ca');
          expect(ca?.stable?.isPlaytest, isFalse);
          expect(ca?.playtest?.isPlaytest, isTrue);

          final cnc = result.mods['cnc'];
          expect(cnc?.stable, isNotNull);
          expect(cnc?.playtest, isNotNull);

          final d2 = result.mods['d2'];
          expect(d2?.stable, isNull);
          expect(d2?.playtest, isNull);

          final ta = result.mods['ta'];
          expect(ta?.stable, isNull);
          expect(ta?.playtest, isNotNull);
        });
      });
    });
  });
}
