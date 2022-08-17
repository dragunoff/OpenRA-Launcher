import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/domain/repositories/installed_mods_repository.abstract.dart';
import 'package:openra_launcher/usecases/get_installed_mods.dart';
import 'package:openra_launcher/usecases/use_case.abstract.dart';

import '../../utils/test_utils.dart';

@GenerateMocks([InstalledModsRepository])
import 'get_installed_mods_test.mocks.dart';

void main() {
  MockInstalledModsRepository mockInstalledModsRepository =
      MockInstalledModsRepository();
  GetInstalledMods usecase = GetInstalledMods(mockInstalledModsRepository);

  final Set<Mod> tMods = {
    TestUtils.generateMod(),
    TestUtils.generateMod().copyWith(id: 'test-2')
  };

  setUp(() {
    mockInstalledModsRepository = MockInstalledModsRepository();
    usecase = GetInstalledMods(mockInstalledModsRepository);
  });

  group('GetInstalledMods', () {
    test('should get installed mods from the repository', () async {
      // given
      when(mockInstalledModsRepository.getInstalledMods())
          .thenAnswer((_) async => Right(tMods));

      // when
      final result = await usecase(NoParams());

      // then
      expect(result, Right(tMods));
      verify(mockInstalledModsRepository.getInstalledMods());
      verifyNoMoreInteractions(mockInstalledModsRepository);
    });
  });
}
