import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/core/error/exceptions.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/data/data_sources/mod_releases_data_source.dart';
import 'package:openra_launcher/data/models/release_model.dart';
import 'package:openra_launcher/data/repositories/mod_releases_repository_impl.dart';
import 'package:openra_launcher/domain/entities/release.dart';

import '../../../utils/test_utils.dart';
@GenerateMocks([ModReleasesDataSource])
import 'mod_releases_repository_impl_test.mocks.dart';

void main() {
  MockModReleasesDataSource mockDataSource = MockModReleasesDataSource();
  ModReleasesRepositoryImpl repository = ModReleasesRepositoryImpl(
    dataSource: mockDataSource,
  );

  setUp(() {
    reset(mockDataSource);
  });

  group('ModReleasesRepositoryImpl', () {
    group('getModReleases', () {
      final Set<ReleaseModel> tModRelesesModels = {
        TestUtils.generateRelease(),
        TestUtils.generateRelease().copyWith(id: 2)
      }
          .map((release) => ReleaseModel(
              modId: release.modId,
              id: release.id,
              version: release.version,
              name: release.name,
              isPlaytest: release.isPlaytest,
              htmlUrl: release.htmlUrl))
          .toSet();

      final Set<Release> tModReleases = tModRelesesModels;

      test('should get mod releases from the data source', () async {
        // given
        when(mockDataSource.getModReleases())
            .thenAnswer((_) async => tModRelesesModels);

        // when
        final result = await repository.getModReleases();

        // then
        verify(mockDataSource.getModReleases());
        expect(result, equals(Right(tModReleases)));
      });

      test('should return a failure when an exception is thrown', () async {
        // given
        when(mockDataSource.getModReleases())
            .thenThrow(const ServerException());

        // when
        final result = await repository.getModReleases();

        // then
        verify(mockDataSource.getModReleases());
        expect(result, equals(Left(ServerFailure())));
      });
    });
  });
}
