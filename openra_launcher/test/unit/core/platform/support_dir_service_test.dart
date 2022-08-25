import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/core/platform/support_dir_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:platform/platform.dart';
import 'package:xdg_directories/xdg_directories.dart' as xdg;

@GenerateMocks([Platform])
import 'support_dir_service_test.mocks.dart';

void main() {
  Platform mockPlatform = MockPlatform();
  MemoryFileSystem mockFileSystem = MemoryFileSystem();
  SupportDirServiceImpl supportDirService = SupportDirServiceImpl(
    platform: mockPlatform,
    fileSystem: mockFileSystem,
  );

  setUp(() {
    mockPlatform = MockPlatform();
    mockFileSystem = MemoryFileSystem();
    supportDirService = SupportDirServiceImpl(
      platform: mockPlatform,
      fileSystem: mockFileSystem,
    );
  });

  group('SupportDirServiceImpl', () {
    group('getAllSupportDirs', () {
      group('on unsupported platforms', () {
        setUp(() {
          when(mockPlatform.operatingSystem).thenReturn('android');
          when(mockPlatform.isLinux).thenReturn(false);
          when(mockPlatform.isWindows).thenReturn(false);
        });

        test('should throw an exception', () {
          expect(() => supportDirService.getAllSupportDirs(),
              throwsA(isA<Exception>()));
        });
      });

      group('on Linux', () {
        const tSystemSupportPath = '/var/games/openra';
        final tModernSupportPath = path.join(xdg.configHome.path, 'openra');
        const tLegacySupportPath = '/home/user/.openra';

        setUp(() async {
          when(mockPlatform.operatingSystem).thenReturn('linux');
          when(mockPlatform.isLinux).thenReturn(true);
          when(mockPlatform.isWindows).thenReturn(false);
          when(mockPlatform.environment).thenReturn({'HOME': '/home/user'});
        });

        test('should return empty set if none of the directories exist',
            () async {
          final out = await supportDirService.getAllSupportDirs();

          expect(out, isEmpty);
        });

        test('should include the system support directory', () async {
          mockFileSystem
              .directory(tSystemSupportPath)
              .createSync(recursive: true);

          final out = await supportDirService.getAllSupportDirs();

          expect(out.any((dir) => dir.path == tSystemSupportPath), true);
        });

        test('should include the modern support directory', () async {
          mockFileSystem
              .directory(tModernSupportPath)
              .createSync(recursive: true);

          final out = await supportDirService.getAllSupportDirs();

          expect(out.any((dir) => dir.path == tModernSupportPath), true);
        });

        test('should include the legacy support directory', () async {
          mockFileSystem
              .directory(tLegacySupportPath)
              .createSync(recursive: true);

          final out = await supportDirService.getAllSupportDirs();

          expect(out.any((dir) => dir.path == tLegacySupportPath), true);
        });
      });

      group('on Windows', () {
        const tSystemSupportPath = 'C:/ProgramData/OpenRA';
        const tModernSupportPath = 'C:/Users/user/AppData/OpenRA';

        setUp(() async {
          when(mockPlatform.operatingSystem).thenReturn('widnows');
          when(mockPlatform.isLinux).thenReturn(false);
          when(mockPlatform.isWindows).thenReturn(true);
          when(mockPlatform.environment).thenReturn({
            'ALLUSERSPROFILE': 'C:/ProgramData',
            'APPDATA': 'C:/Users/user/AppData'
          });
        });

        test('should return empty set if none of the directories exist',
            () async {
          final out = await supportDirService.getAllSupportDirs();

          expect(out, isEmpty);
        });

        test('should include the system support directory', () async {
          mockFileSystem
              .directory(tSystemSupportPath)
              .createSync(recursive: true);

          final out = await supportDirService.getAllSupportDirs();

          expect(out.any((dir) => dir.path == tSystemSupportPath), true);
        });

        test('should include the modern support directory', () async {
          mockFileSystem
              .directory(tModernSupportPath)
              .createSync(recursive: true);

          final out = await supportDirService.getAllSupportDirs();

          expect(out.any((dir) => dir.path == tModernSupportPath), true);
        });

        test('should include the legacy support directory', () async {
          final docsDir = await getApplicationDocumentsDirectory();
          final tLegacySupportPath = path.join(docsDir.path, 'OpenRA');
          mockFileSystem
              .directory(tLegacySupportPath)
              .createSync(recursive: true);

          final out = await supportDirService.getAllSupportDirs();

          expect(out.any((dir) => dir.path == tLegacySupportPath), true);
        });
      });
    });
  });
}
