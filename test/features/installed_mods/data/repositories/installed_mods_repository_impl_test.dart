import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/installed_mods/data/data_sources/installed_mods_data_source.dart';
import 'package:openra_launcher/features/installed_mods/data/models/mod_model.dart';
import 'package:openra_launcher/features/installed_mods/data/repositories/installed_mods_repository_impl.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';

import '../../../../../testing/utils/test_utils.dart';
@GenerateMocks([InstalledModsDataSource])
import 'installed_mods_repository_impl_test.mocks.dart';

void main() {
  provideDummy<TaskEither<FileSystemFailure, Set<ModModel>>>(
    TaskEither.left(const FileSystemFailure()),
  );
  MockInstalledModsDataSource mockDataSource = MockInstalledModsDataSource();
  InstalledModsRepositoryImpl repository = InstalledModsRepositoryImpl(
    dataSource: mockDataSource,
  );

  setUp(() {
    reset(mockDataSource);
  });

  group('InstalledModsRepositoryImpl', () {
    group('getInstalledMods', () {
      final Set<ModModel> tInstalledModsModels =
          {
                TestUtils.generateMod(),
                TestUtils.generateMod().copyWith(id: 'test-2'),
              }
              .map(
                (mod) => ModModel(
                  key: mod.key,
                  id: mod.id,
                  version: mod.version,
                  title: mod.title,
                  launchPath: mod.launchPath,
                  launchArgs: mod.launchArgs,
                ),
              )
              .toSet();
      final Set<Mod> tInstalledMods = tInstalledModsModels;

      test('should get installed mods from the data source', () async {
        // given
        when(
          mockDataSource.getInstalledMods(),
        ).thenAnswer((_) => TaskEither.right(tInstalledModsModels));

        // when
        final result = await repository.getInstalledMods().run();

        // then
        verify(mockDataSource.getInstalledMods());
        result.fold((failure) => fail('Expected Either.Right'), (result) {
          expect(result, equals(tInstalledMods));
        });
      });

      test('should return a failure when the scan is unsuccessful', () async {
        // given
        when(
          mockDataSource.getInstalledMods(),
        ).thenAnswer((_) => TaskEither.left(const FileSystemFailure()));

        // when
        final result = await repository.getInstalledMods().run();

        // then
        verify(mockDataSource.getInstalledMods());

        result.match(
          (left) => expect(left, isA<FileSystemFailure>()),
          (_) => fail('Expected Either.Left'),
        );
      });
    });
  });
}
