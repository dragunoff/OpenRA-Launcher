import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/constants/constants.dart';
import 'package:openra_launcher/core/error/exceptions.dart';
import 'package:openra_launcher/data/data_sources/mod_releases_data_source.dart';
import 'package:openra_launcher/data/models/release_model.dart';

import '../../../utils/test_utils.dart';
@GenerateMocks([http.Client])
import 'mod_releases_data_source_impl_test.mocks.dart';

void main() {
  final mockClient = MockClient();
  ModReleasesDataSourceImpl dataSource = ModReleasesDataSourceImpl(
    client: mockClient,
  );

  final tResponse =
      TestUtils.getJsonStringFromFile('github_json/release-is-latest.json');
  final tReleaseIsLatest = tResponse;
  final tPlaytestIsLatest =
      TestUtils.getJsonStringFromFile('github_json/playtest-is-latest.json');

  final tMod = Constants.modRepos.entries.first.key;
  final tModRepo = Constants.modRepos.entries.first.value;
  const tOfficialMods = Constants.officialModIds;

  setUp(() {
    dataSource = ModReleasesDataSourceImpl(client: mockClient);

    reset(mockClient);
    when(mockClient.read(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => tResponse);
  });

  group('ModReleasesDataSourceImpl', () {
    group('getModReleases', () {
      test('should close connection when done', () async {
        // when
        await dataSource.getModReleases({tMod});

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

        // then, when
        expect(
            () async => await dataSource.getModReleases({tMod}),
            throwsA(const TypeMatcher<ServerException>()
                .having((e) => e.message, 'message', contains('reason'))));
      });

      test(
          'should perform a GET requet against the release endpoint of queried mods',
          () async {
        // when
        await dataSource.getModReleases({tMod});

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
        await dataSource.getModReleases({tMod});

        // then
        verifyNever(mockClient.read(
          Uri.parse('https://api.github.com/repos/$tModRepo/releases'),
        ));
      });

      test(
          'should perform a single GET requet against OpenRA repo for official mods (TD, D2k, RA)',
          () async {
        // when
        await dataSource.getModReleases(tOfficialMods);

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
        final result = await dataSource.getModReleases({tMod});

        // then
        expect(result, <ReleaseModel>{});
      });

      test('should return latest releases for official mods', () async {
        // given
        when(mockClient.read(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => tResponse);

        // when
        final result = await dataSource.getModReleases(tOfficialMods);

        // then
        expect(result, hasLength(3));
      });

      test(
          'should return releases and playtest for mods where release is older',
          () async {
        when(mockClient.read(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => tPlaytestIsLatest);

        // when
        final result = await dataSource.getModReleases({'ca'});

        // then
        expect(result.where((r) => r.modId == 'ca'), hasLength(2));
        expect(result.where((r) => !r.isPlaytest), hasLength(1));
        expect(result.where((r) => r.isPlaytest), hasLength(1));
      });

      test('should return only release for mods where playtest is older',
          () async {
        when(mockClient.read(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => tReleaseIsLatest);

        // when
        final result = await dataSource.getModReleases({'cnc'});

        // then
        expect(result.where((r) => r.modId == 'cnc'), hasLength(1));
        expect(result.where((r) => !r.isPlaytest), hasLength(1));
        expect(result.where((r) => r.isPlaytest), hasLength(0));
      });
    });
  });
}
