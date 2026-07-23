import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/core/platform/support_dir_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:platform/platform.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
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
    PathProviderPlatform.instance = FakePathProviderPlatform();

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
          when(mockPlatform.isMacOS).thenReturn(false);
        });

        test('should throw an exception', () {
          expect(() => supportDirService.getAllSupportDirs(),
              throwsA(isA<Exception>()));
        });
      });

      group('on Linux', () {
        setUp(() async {
          when(mockPlatform.operatingSystem).thenReturn('linux');
          when(mockPlatform.isLinux).thenReturn(true);
          when(mockPlatform.isWindows).thenReturn(false);
          when(mockPlatform.isMacOS).thenReturn(false);
          when(mockPlatform.environment).thenReturn({'HOME': '/home/user'});
        });

        test('should return empty set if none of the directories exist',
            () async {
          final out = await supportDirService.getAllSupportDirs();

          expect(out, isEmpty);
        });

        test('should include the system support directory', () async {
          const tSystemSupportPath = '/var/games/openra';

          mockFileSystem
              .directory(tSystemSupportPath)
              .createSync(recursive: true);

          final out = await supportDirService.getAllSupportDirs();

          expect(out.any((dir) => dir.path == tSystemSupportPath), true);
        });

        test('should include the modern support directory', () async {
          final tModernSupportPath = path.join(xdg.configHome.path, 'openra');

          mockFileSystem
              .directory(tModernSupportPath)
              .createSync(recursive: true);

          final out = await supportDirService.getAllSupportDirs();

          expect(out.any((dir) => dir.path == tModernSupportPath), true);
        });

        test('should include the legacy support directory', () async {
          const tLegacySupportPath = '/home/user/.openra';

          mockFileSystem
              .directory(tLegacySupportPath)
              .createSync(recursive: true);

          final out = await supportDirService.getAllSupportDirs();

          expect(out.any((dir) => dir.path == tLegacySupportPath), true);
        });
      });

      group('on Windows', () {
        setUp(() async {
          when(mockPlatform.operatingSystem).thenReturn('widnows');
          when(mockPlatform.isLinux).thenReturn(false);
          when(mockPlatform.isWindows).thenReturn(true);
          when(mockPlatform.isMacOS).thenReturn(false);
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
          const tSystemSupportPath = 'C:/ProgramData/OpenRA';

          mockFileSystem
              .directory(tSystemSupportPath)
              .createSync(recursive: true);

          final out = await supportDirService.getAllSupportDirs();

          expect(out.any((dir) => dir.path == tSystemSupportPath), true);
        });

        test('should include the modern support directory', () async {
          const tModernSupportPath = 'C:/Users/user/AppData/OpenRA';

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

    group('on MacOS', () {
      setUp(() async {
        when(mockPlatform.operatingSystem).thenReturn('macos');
        when(mockPlatform.isLinux).thenReturn(false);
        when(mockPlatform.isWindows).thenReturn(false);
        when(mockPlatform.isMacOS).thenReturn(true);
        when(mockPlatform.environment).thenReturn({'HOME': '/home/user'});
      });

      test('should return empty set if none of the directories exist',
          () async {
        final out = await supportDirService.getAllSupportDirs();

        expect(out, isEmpty);
      });

      test('should include the system support directory', () async {
        const tSystemSupportPath = '/Library/Application Support/OpenRA/';

        mockFileSystem
            .directory(tSystemSupportPath)
            .createSync(recursive: true);

        final out = await supportDirService.getAllSupportDirs();

        expect(out.any((dir) => dir.path == tSystemSupportPath), true);
      });

      test(
          'should include the user support directory (modern and legacy are the same)',
          () async {
        final appSupportDir = await getApplicationSupportDirectory();
        final tModernSupportPath =
            path.join(appSupportDir.parent.path, 'OpenRA');
        final tLegacySupportPath = tModernSupportPath;

        mockFileSystem
            .directory(tModernSupportPath)
            .createSync(recursive: true);

        final out = await supportDirService.getAllSupportDirs();

        expect(out.any((dir) => dir.path == tModernSupportPath), true);
        expect(out.any((dir) => dir.path == tLegacySupportPath), true);
      });
    });
  });
}

// Mock Path Provider
const String kTemporaryPath = 'temporaryPath';
const String kApplicationSupportPath = 'applicationSupportPath/application';
const String kDownloadsPath = 'downloadsPath';
const String kLibraryPath = 'libraryPath';
const String kApplicationDocumentsPath = 'applicationDocumentsPath';
const String kExternalCachePath = 'externalCachePath';
const String kExternalStoragePath = 'externalStoragePath';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return kTemporaryPath;
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return kApplicationSupportPath;
  }

  @override
  Future<String?> getLibraryPath() async {
    return kLibraryPath;
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return kApplicationDocumentsPath;
  }

  @override
  Future<String?> getExternalStoragePath() async {
    return kExternalStoragePath;
  }

  @override
  Future<List<String>?> getExternalCachePaths() async {
    return <String>[kExternalCachePath];
  }

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async {
    return <String>[kExternalStoragePath];
  }

  @override
  Future<String?> getDownloadsPath() async {
    return kDownloadsPath;
  }
}
