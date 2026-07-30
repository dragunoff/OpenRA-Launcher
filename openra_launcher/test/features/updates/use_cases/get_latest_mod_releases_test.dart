import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/features/updates/domain/repositories/mod_releases_repository.abstract.dart';
import 'package:openra_launcher/features/updates/domain/use_cases/get_latest_mod_releases.dart';

import '../../../../testing/utils/test_utils.dart';
@GenerateMocks([ModReleasesRepository])
import 'get_latest_mod_releases_test.mocks.dart';

void main() {
  provideDummy<TaskEither<ServerFailure, Set<Release>>>(
    TaskEither.left(const ServerFailure()),
  );

  MockModReleasesRepository mockModReleasesRepository =
      MockModReleasesRepository();
  GetLatestModReleases usecase =
      GetLatestModReleases(mockModReleasesRepository);

  final Set<Release> tReleases = {
    TestUtils.generateRelease(),
    TestUtils.generateRelease().copyWith(id: 2),
    TestUtils.generateRelease().copyWith(id: 3, isPlaytest: true),
    TestUtils.generateRelease().copyWith(id: 4, isPlaytest: true),
  };

  final tMods = {'test'};

  setUp(() {
    mockModReleasesRepository = MockModReleasesRepository();
    usecase = GetLatestModReleases(mockModReleasesRepository);
  });

  group('GetLatestModReleases', () {
    test('should get mod releases from the repository', () async {
      // given
      when(mockModReleasesRepository.getModReleases(any))
          .thenAnswer((_) => TaskEither.right(tReleases));

      // when
      final response = await usecase(Params(mods: tMods)).run();

      // then
      expect(response, Right(tReleases));
      verify(mockModReleasesRepository.getModReleases(tMods));
      verifyNoMoreInteractions(mockModReleasesRepository);
    });
  });
}
