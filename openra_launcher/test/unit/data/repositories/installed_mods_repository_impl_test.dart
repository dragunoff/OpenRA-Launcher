import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/core/error/exceptions.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/data/data_sources/installed_mods_data_source.dart';
import 'package:openra_launcher/data/models/mod_model.dart';
import 'package:openra_launcher/data/repositories/installed_mods_repository_impl.dart';
import 'package:openra_launcher/domain/entities/mod.dart';

import '../../../utils/test_utils.dart';
@GenerateMocks([InstalledModsDataSource])
import 'installed_mods_repository_impl_test.mocks.dart';

void main() {
  MockInstalledModsDataSource mockDataSource = MockInstalledModsDataSource();
  InstalledModsRepositoryImpl repository = InstalledModsRepositoryImpl(
    dataSource: mockDataSource,
  );

  setUp(() {
    reset(mockDataSource);
  });

  group('InstalledModsRepositoryImpl', () {
    group('getInstalledMods', () {
      final Set<ModModel> tInstalledModsModels = {
        TestUtils.generateMod(),
        TestUtils.generateMod().copyWith(id: 'test-2')
      }
          .map((mod) => ModModel(
              key: mod.key,
              id: mod.id,
              version: mod.version,
              title: mod.title,
              launchPath: mod.launchPath,
              launchArgs: mod.launchArgs))
          .toSet();
      final Set<Mod> tInstalledMods = tInstalledModsModels;

      test('should get installed mods from the data source', () async {
        // given
        when(mockDataSource.getInstalledMods())
            .thenAnswer((_) async => tInstalledModsModels);

        // when
        final result = await repository.getInstalledMods();

        // then
        verify(mockDataSource.getInstalledMods());
        expect(result, equals(Right(tInstalledMods)));
      });

      test('should return a failure when the scan is unsuccessful', () async {
        // given
        when(mockDataSource.getInstalledMods())
            .thenThrow(FileSystemException());

        // when
        final result = await repository.getInstalledMods();

        // then
        verify(mockDataSource.getInstalledMods());
        expect(result, equals(Left(FileSystemFailure())));
      });
    });
  });
}
