import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/core/platform/support_dir_service.dart';
import 'package:openra_launcher/features/installed_mods/data/data_sources/installed_mods_data_source.dart';

import '../../../../../testing/utils/test_utils.dart';
@GenerateMocks([SupportDirService])
import 'installed_mods_data_source_test.mocks.dart';

void main() {
  FlutterError.onError = null;

  provideDummy<TaskEither<FileSystemFailure, Set<Directory>>>(
    TaskEither.left(const FileSystemFailure()),
  );

  MemoryFileSystem mockFileSystem = MemoryFileSystem();
  SupportDirService mockSupportDirService = MockSupportDirService();
  InstalledModsDataSourceImpl dataSource = InstalledModsDataSourceImpl(
    fileSystem: mockFileSystem,
    supportDirService: mockSupportDirService,
  );

  setUp(() {
    mockFileSystem = MemoryFileSystem();
    mockSupportDirService = MockSupportDirService();
    dataSource = InstalledModsDataSourceImpl(
      fileSystem: mockFileSystem,
      supportDirService: mockSupportDirService,
    );
  });

  group('InstalledModsDataSourceImpl', () {
    group('getInstalledMods', () {
      test('should return an empty set if no support directories exist',
          () async {
        when(mockSupportDirService.getAllSupportDirs()).thenAnswer((_) {
          Set<Directory> dirs = {};
          return TaskEither.right(dirs);
        });

        final out = await dataSource.getInstalledMods().run();

        out.fold(
          (failure) => fail('Expected Either.Right'),
          (result) {
            expect(result, isEmpty);
          },
        );
      });

      group('when support directories exist', () {
        setUp(() {
          mockFileSystem.directory('system-support').createSync();
          mockFileSystem.directory('user-support').createSync();

          when(mockSupportDirService.getAllSupportDirs()).thenAnswer((_) {
            Set<Directory> dirs = {};
            dirs.add(mockFileSystem.directory('system-support'));
            dirs.add(mockFileSystem.directory('user-support'));
            return TaskEither.right(dirs);
          });
        });

        test('should return an empty set if no metadata directories exist',
            () async {
          final out = await dataSource.getInstalledMods().run();

          out.fold(
            (failure) => fail('Expected Either.Right'),
            (result) {
              expect(result, isEmpty);
            },
          );
        });

        group('and metadata directories exist', () {
          setUp(() {
            mockFileSystem.directory('system-support/ModMetadata').createSync();
            mockFileSystem.directory('user-support/ModMetadata').createSync();
          });

          test('should return an empty set if no metadata files exist',
              () async {
            final out = await dataSource.getInstalledMods().run();

            out.fold(
              (failure) => fail('Expected Either.Right'),
              (result) {
                expect(result, isEmpty);
              },
            );
          });

          test('should load all mods from the mod metadata directories',
              () async {
            // given
            mockFileSystem
                .file('home/user/OpenRA/OpenRA-Red-Alert-x86_64.AppImage')
                .createSync(recursive: true);

            mockFileSystem
                .file('system-support/ModMetadata/ra-release-20210321.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('valid-ra.yaml').readAsStringSync());

            mockFileSystem
                .file('home/user/OpenRA/OpenRA-Tiberian-Dawn-x86_64.AppImage')
                .createSync(recursive: true);

            mockFileSystem
                .file('user-support/ModMetadata/cnc-release-20210321.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('valid-cnc.yaml').readAsStringSync());

            // when
            final out = await dataSource.getInstalledMods().run();

            // then
            out.fold(
              (failure) => fail('Expected Either.Right'),
              (result) {
                expect(result, hasLength(2));
              },
            );
          });

          test('should deduplicate mods with the same metadata', () async {
            // given
            mockFileSystem
                .file('home/user/OpenRA/OpenRA-Red-Alert-x86_64.AppImage')
                .createSync(recursive: true);

            mockFileSystem
                .file('system-support/ModMetadata/ra-release-20210321.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('valid-ra.yaml').readAsStringSync());

            mockFileSystem
                .file(
                    'system-support/ModMetadata/ra-release-20210321-copy.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('valid-ra.yaml').readAsStringSync());

            mockFileSystem
                .file('user-support/ModMetadata/ra-release-20210321.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('valid-ra.yaml').readAsStringSync());

            mockFileSystem
                .file('user-support/ModMetadata/ra-release-20210321-copy.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('valid-ra.yaml').readAsStringSync());

            // when
            final out = await dataSource.getInstalledMods().run();

            // then
            out.fold((failure) => fail('Expected Either.Right'), (result) {
              expect(result, hasLength(1));
            });
          });

          test('should not load dev version mods', () async {
            // given
            mockFileSystem
                .file('home/user/code/OpenRA/launch-game.sh')
                .createSync(recursive: true);

            mockFileSystem
                .file('system-support/ModMetadata/ts-{DEV_VERSION}.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('valid-dev-version.yaml')
                        .readAsStringSync());

            // when
            final out = await dataSource.getInstalledMods().run();

            // then
            out.fold(
              (failure) => fail('Expected Either.Right'),
              (result) {
                expect(result, isEmpty);
              },
            );
          });

          test('should not load mods with invalid metadata', () async {
            // given
            mockFileSystem
                .file('home/user/code/OpenRA/no-id.sh')
                .createSync(recursive: true);

            mockFileSystem
                .file('system-support/ModMetadata/no-id.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('no-id.yaml').readAsStringSync());

            // when
            final out = await dataSource.getInstalledMods().run();

            // then
            out.fold(
              (failure) => fail('Expected Either.Right'),
              (result) {
                expect(result, isEmpty);
              },
            );
          });

          test('should not load mods with non-existing launch path', () async {
            // given
            mockFileSystem
                .file('system-support/ModMetadata/ra-release-20210321.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('valid-ra.yaml').readAsStringSync());

            // when
            final out = await dataSource.getInstalledMods().run();

            // then
            out.fold(
              (failure) => fail('Expected Either.Right'),
              (result) {
                expect(result, isEmpty);
              },
            );
          });

          test('should not load mods whose key does not match the filename',
              () async {
            // given
            mockFileSystem
                .file('home/user/OpenRA/OpenRA-Red-Alert-x86_64.AppImage')
                .createSync(recursive: true);

            mockFileSystem
                .file('system-support/ModMetadata/bogus-filename.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('valid-ra.yaml').readAsStringSync());

            // when
            final out = await dataSource.getInstalledMods().run();

            // then
            out.fold(
              (failure) => fail('Expected Either.Right'),
              (result) {
                expect(result, isEmpty);
              },
            );
          });
        });
      });
    });
  });
}
