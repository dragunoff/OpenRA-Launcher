import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/domain/entities/release.dart';
import 'package:openra_launcher/domain/repositories/mod_releases_repository.abstract.dart';
import 'package:openra_launcher/usecases/get_mod_releases.dart';
import 'package:openra_launcher/usecases/use_case.abstract.dart';

import '../../utils/test_utils.dart';

@GenerateMocks([ModReleasesRepository])
import 'get_mod_releases_test.mocks.dart';

void main() {
  MockModReleasesRepository mockModReleasesRepository =
      MockModReleasesRepository();
  GetModReleases usecase = GetModReleases(mockModReleasesRepository);

  final Set<Release> tReleases = {
    TestUtils.generateRelease(),
    TestUtils.generateRelease().copyWith(id: 2)
  };

  setUp(() {
    mockModReleasesRepository = MockModReleasesRepository();
    usecase = GetModReleases(mockModReleasesRepository);
  });

  group('GetModReleases', () {
    test('should get mod releases from the repository', () async {
      // given
      when(mockModReleasesRepository.getLatestReleases())
          .thenAnswer((_) async => Right(tReleases));

      // when
      final result = await usecase(NoParams());

      // then
      expect(result, Right(tReleases));
      verify(mockModReleasesRepository.getLatestReleases());
      verifyNoMoreInteractions(mockModReleasesRepository);
    });
  });
}
