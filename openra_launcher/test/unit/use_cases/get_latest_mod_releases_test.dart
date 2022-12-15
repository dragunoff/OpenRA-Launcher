import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/domain/entities/release.dart';
import 'package:openra_launcher/domain/repositories/mod_releases_repository.abstract.dart';
import 'package:openra_launcher/usecases/get_latest_mod_releases.dart';
import 'package:openra_launcher/usecases/use_case.abstract.dart';

import '../../utils/test_utils.dart';

@GenerateMocks([ModReleasesRepository])
import 'get_latest_mod_releases_test.mocks.dart';

void main() {
  MockModReleasesRepository mockModReleasesRepository =
      MockModReleasesRepository();
  GetLatestModReleases usecase =
      GetLatestModReleases(mockModReleasesRepository);

  final Set<Release> tAllReleases = {
    TestUtils.generateRelease(),
    TestUtils.generateRelease().copyWith(id: 2),
    TestUtils.generateRelease().copyWith(id: 3, isPlaytest: true),
    TestUtils.generateRelease().copyWith(id: 4, isPlaytest: true),
  };

  final Set<Release> tReleases =
      tAllReleases.where((r) => !r.isPlaytest).toSet();

  setUp(() {
    mockModReleasesRepository = MockModReleasesRepository();
    usecase = GetLatestModReleases(mockModReleasesRepository);
  });

  group('GetLatestModReleases', () {
    test('should get mod releases from the repository', () async {
      // given
      when(mockModReleasesRepository.getModReleases())
          .thenAnswer((_) async => Right(tAllReleases));

      // when
      final response = await usecase(NoParams());
      final result =
          response.foldRight<Set<Release>>(<Release>{}, ((r, previous) => r));

      // then
      expect(result, tReleases);
      verify(mockModReleasesRepository.getModReleases());
      verifyNoMoreInteractions(mockModReleasesRepository);
    });
  });
}
