import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/core/platform/support_dir_service.dart';
import 'package:openra_launcher/data/data_sources/installed_mods_data_source.dart';

import '../../../utils/test_utils.dart';
@GenerateMocks([SupportDirService])
import 'installed_mods_data_source_impl_test.mocks.dart';

void main() {
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
          return Future.value(dirs);
        });

        final out = await dataSource.getInstalledMods();

        expect(out, isEmpty);
      });

      group('when support directories exist', () {
        setUp(() {
          mockFileSystem.directory('system-support').createSync();
          mockFileSystem.directory('user-support').createSync();

          when(mockSupportDirService.getAllSupportDirs()).thenAnswer((_) {
            Set<Directory> dirs = {};
            dirs.add(mockFileSystem.directory('system-support'));
            dirs.add(mockFileSystem.directory('user-support'));
            return Future.value(dirs);
          });
        });

        test('should return an empty set if no metadata directories exist',
            () async {
          final out = await dataSource.getInstalledMods();

          expect(out, isEmpty);
        });

        group('and metadata directories exist', () {
          setUp(() {
            mockFileSystem.directory('system-support/ModMetadata').createSync();
            mockFileSystem.directory('user-support/ModMetadata').createSync();
          });

          test('should return an empty set if no metadata files exist',
              () async {
            final out = await dataSource.getInstalledMods();

            expect(out, isEmpty);
          });

          test('should load all mods from the mod metadata directories',
              () async {
            // given
            mockFileSystem
                .file('home/user/OpenRA/OpenRA-Red-Alert-x86_64.AppImage')
                .createSync(recursive: true);

            mockFileSystem
                .file('system-support/ModMetadata/ra-release-20210321.yaml')
                .createSync();
            mockFileSystem
                .file('system-support/ModMetadata/ra-release-20210321.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('valid.yaml').readAsStringSync());

            mockFileSystem
                .file('user-support/ModMetadata/valid.yaml')
                .createSync();
            mockFileSystem
                .file('user-support/ModMetadata/valid.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('valid.yaml').readAsStringSync());

            // when
            final out = await dataSource.getInstalledMods();

            // then
            expect(out.length, 1);
          });

          test('should not load dev version mods', () async {
            // given
            mockFileSystem
                .file('system-support/ModMetadata/ts-{DEV_VERSION}.yaml')
                .createSync();
            mockFileSystem
                .file('system-support/ModMetadata/ts-{DEV_VERSION}.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('valid-dev-version.yaml')
                        .readAsStringSync());

            // when
            final out = await dataSource.getInstalledMods();

            // then
            expect(out, isEmpty);
          });

          test('should not load mods with invalid metadata', () async {
            mockFileSystem
                .file('system-support/ModMetadata/ra-release-20210321.yaml')
                .createSync();
            mockFileSystem
                .file('system-support/ModMetadata/ra-release-20210321.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('no-id.yaml').readAsStringSync());

            // when
            final out = await dataSource.getInstalledMods();

            // then
            expect(out, isEmpty);
          });

          test('should not load mods with non-existing launch path', () async {
            // given
            mockFileSystem
                .file('system-support/ModMetadata/ra-release-20210321.yaml')
                .createSync();
            mockFileSystem
                .file('system-support/ModMetadata/ra-release-20210321.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('valid.yaml').readAsStringSync());

            // when
            final out = await dataSource.getInstalledMods();

            // then
            expect(out, isEmpty);
          });

          test('should not load mods whose key does not match the filename',
              () async {
            // given
            mockFileSystem
                .file('home/user/OpenRA/OpenRA-Red-Alert-x86_64.AppImage')
                .createSync(recursive: true);

            mockFileSystem
                .file('system-support/ModMetadata/bogus-filename.yaml')
                .createSync();
            mockFileSystem
                .file('system-support/ModMetadata/bogus-filename.yaml')
                .writeAsStringSync(
                    TestUtils.getYamlFile('valid.yaml').readAsStringSync());

            // when
            final out = await dataSource.getInstalledMods();

            // then
            expect(out, isEmpty);
          });
        });
      });
    });
  });
}
