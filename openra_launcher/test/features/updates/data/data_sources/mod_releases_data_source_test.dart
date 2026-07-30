import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/constants/mod_constants.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/core/network/http_client_service.dart';
import 'package:openra_launcher/features/updates/data/data_sources/mod_releases_data_source.dart';
import 'package:openra_launcher/features/updates/data/models/release_model.dart';

import '../../../../../testing/utils/test_utils.dart';
@GenerateMocks([HttpClientService])
import 'mod_releases_data_source_test.mocks.dart';

void main() {
  final mockClient = MockHttpClientService();
  ModReleasesDataSourceImpl dataSource = ModReleasesDataSourceImpl(
    httpClientService: mockClient,
  );

  final tResponse =
      TestUtils.getJsonStringFromFile('github_json/release-is-latest.json');
  final tReleaseIsLatest = tResponse;
  final tPlaytestIsLatest =
      TestUtils.getJsonStringFromFile('github_json/playtest-is-latest.json');

  final tMod = ModConstants.modRepos.entries.first.key;
  final tModRepo = ModConstants.modRepos.entries.first.value;
  const tOfficialMods = ModConstants.officialModIds;

  setUp(() {
    dataSource = ModReleasesDataSourceImpl(httpClientService: mockClient);

    reset(mockClient);
    when(mockClient.read(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => tResponse);
  });

  group('ModReleasesDataSourceImpl', () {
    group('getModReleases', () {
      test('should close connection when done', () async {
        // when
        await dataSource.getModReleases({tMod}).run();

        // then
        verify(mockClient.read(
                Uri.parse('https://api.github.com/repos/$tModRepo/releases')))
            .called(1);
        verify(mockClient.close()).called(1);
        verifyNoMoreInteractions(mockClient);
      });

      test('should throw [ServerException] when HTTP client throws', () async {
        // given
        when(mockClient.read(any, headers: anyNamed('headers')))
            .thenThrow(http.ClientException('reason'));

        // when
        final result = await dataSource.getModReleases({tMod}).run();

        // then
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (result) => fail('Expected Either.Left'),
        );
      });

      test(
          'should perform a GET requet against the release endpoint of queried mods',
          () async {
        // when
        await dataSource.getModReleases({tMod}).run();

        // then
        verify(mockClient.read(
          Uri.parse('https://api.github.com/repos/$tModRepo/releases'),
        )).called(1);
      });

      test('should not perform GET requets for unsupported mods', () async {
        // given
        const tMod = 'unsupportedMod';
        const tModRepo = 'unsupportedMod/unsupportedMod';

        // when
        await dataSource.getModReleases({tMod}).run();

        // then
        verifyNever(mockClient.read(
          Uri.parse('https://api.github.com/repos/$tModRepo/releases'),
        ));
      });

      test(
          'should perform a single GET requet against OpenRA repo for official mods (TD, D2k, RA)',
          () async {
        // when
        await dataSource.getModReleases(tOfficialMods).run();

        // then
        verify(mockClient.read(
          Uri.parse('https://api.github.com/repos/OpenRA/OpenRA/releases'),
        )).called(1);
      });

      test('should return an empty set if no releases', () async {
        // given
        when(mockClient.read(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => '[]');

        // when
        final result = await dataSource.getModReleases({tMod}).run();

        // then
        result.fold(
          (failure) => fail('Expected Either.Right'),
          (result) {
            expect(result, <ReleaseModel>{});
          },
        );
      });

      test('should return latest releases for official mods', () async {
        // given
        when(mockClient.read(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => tResponse);

        // when
        final result = await dataSource.getModReleases(tOfficialMods).run();

        // then
        result.fold(
          (failure) => fail('Expected Either.Right'),
          (result) {
            expect(result, hasLength(3));
          },
        );
      });

      test(
          'should return releases and playtest for mods where release is older',
          () async {
        when(mockClient.read(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => tPlaytestIsLatest);

        // when
        final result = await dataSource.getModReleases({'ca'}).run();

        // then
        result.fold(
          (failure) => fail('Expected Either.Right'),
          (result) {
            expect(result.where((r) => r.modId == 'ca'), hasLength(2));
            expect(result.where((r) => !r.isPlaytest), hasLength(1));
            expect(result.where((r) => r.isPlaytest), hasLength(1));
          },
        );
      });

      test('should return only release for mods where playtest is older',
          () async {
        when(mockClient.read(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => tReleaseIsLatest);

        // when
        final result = await dataSource.getModReleases({'cnc'}).run();

        // then
        result.fold(
          (failure) => fail('Expected Either.Right'),
          (result) {
            expect(result.where((r) => r.modId == 'cnc'), hasLength(1));
            expect(result.where((r) => !r.isPlaytest), hasLength(1));
            expect(result.where((r) => r.isPlaytest), hasLength(0));
          },
        );
      });
    });
  });
}
