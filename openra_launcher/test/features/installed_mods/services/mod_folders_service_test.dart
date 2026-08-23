import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:openra_launcher/core/error/error_reporter.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/core/platform/support_dir_service.dart';
import 'package:openra_launcher/features/installed_mods/services/mod_folders_service.dart';
import 'package:openra_launcher/features/installed_mods/services/mod_launch_service.dart'
    show LaunchProcessStarter;
import 'package:path/path.dart' as path;
import 'package:platform/platform.dart';
import '../../../../testing/utils/test_utils.dart';

void main() {
  late MemoryFileSystem fileSystem;

  setUp(() {
    fileSystem = MemoryFileSystem();
  });

  group('ProcessModFoldersService', () {
    group('openMapsFolder', () {
      test('should open the maps folder of the mod', () async {
        final folderPath = await _createModFolder(fileSystem, 'maps');
        final started = <List<String>>[];

        final result = await _createService(
          fileSystem: fileSystem,
          platformOperatingSystem: 'linux',
          starter: _recordingStarter(started),
        ).openMapsFolder(TestUtils.generateMod()).run();

        expect(result.isRight(), true);
        expect(started, [
          ['xdg-open', folderPath],
        ]);
      });

      test('should fall back to the closest existing ancestor directory',
          () async {
        const supportPath = '/home/user/.openra';
        final modFolderPath = path.join(supportPath, 'maps', 'test');
        fileSystem.directory(modFolderPath).createSync(recursive: true);
        final started = <List<String>>[];

        await _createService(
          fileSystem: fileSystem,
          platformOperatingSystem: 'linux',
          starter: _recordingStarter(started),
        ).openMapsFolder(TestUtils.generateMod()).run();

        expect(started, [
          ['xdg-open', modFolderPath],
        ]);
      });
    });

    group('openReplaysFolder', () {
      test('should open the replays folder of the mod', () async {
        final folderPath = await _createModFolder(fileSystem, 'replays');
        final started = <List<String>>[];

        final result = await _createService(
          fileSystem: fileSystem,
          platformOperatingSystem: 'linux',
          starter: _recordingStarter(started),
        ).openReplaysFolder(TestUtils.generateMod()).run();

        expect(result.isRight(), true);
        expect(started, [
          ['xdg-open', folderPath],
        ]);
      });

      test('should open one explorer window per support directory', () async {
        const legacySupportPath = '/home/user/.openra';
        const modernSupportPath = '/home/user/.config/openra';
        fileSystem
            .directory(path.join(legacySupportPath, 'replays', 'test'))
            .createSync(recursive: true);
        fileSystem
            .directory(path.join(modernSupportPath, 'replays', 'test'))
            .createSync(recursive: true);

        final started = <List<String>>[];
        final result = await _createService(
          fileSystem: fileSystem,
          platformOperatingSystem: 'windows',
          starter: _recordingStarter(started),
          supportPaths: const {legacySupportPath, modernSupportPath},
        ).openReplaysFolder(TestUtils.generateMod()).run();

        expect(result.isRight(), true);
        expect(started.length, 2);
        expect(
          started,
          containsAll([
            ['explorer', path.join(legacySupportPath, 'replays', 'test')],
            ['explorer', path.join(modernSupportPath, 'replays', 'test')],
          ]),
        );
      });

      test('should use the open command on macOS', () async {
        final folderPath = await _createModFolder(fileSystem, 'replays');
        final started = <List<String>>[];

        final result = await _createService(
          fileSystem: fileSystem,
          platformOperatingSystem: 'macos',
          starter: _recordingStarter(started),
        ).openReplaysFolder(TestUtils.generateMod()).run();

        expect(result.isRight(), true);
        expect(started, [
          ['open', folderPath],
        ]);
      });
    });

    test('should return a left with PlatformFailure when starting fails',
        () async {
      await _createModFolder(fileSystem, 'maps');
      final reportedErrors = <FlutterErrorDetails>[];

      final result = await _createService(
        fileSystem: fileSystem,
        platformOperatingSystem: 'linux',
        starter: _ThrowingProcessStarter(),
        reportError: reportedErrors.add,
      ).openMapsFolder(TestUtils.generateMod()).run();

      result.fold(
        (failure) => expect(failure, isA<PlatformFailure>()),
        (_) => fail('Expected Either.Left'),
      );
      expect(reportedErrors.length, 1);
    });

    test('should return a left when resolving the support dirs fails',
        () async {
      final service = ProcessModFoldersService(
        supportDirService: _FakeSupportDirService(
          TaskEither.left(const FileSystemFailure('boom')),
        ),
        fileSystem: fileSystem,
        platform: FakePlatform(operatingSystem: 'linux'),
        starter: _FakeProcessStarter((_, __) async {}),
      );

      final result =
          await service.openMapsFolder(TestUtils.generateMod()).run();

      expect(result.isLeft(), true);
    });
  });
}

Future<String> _createModFolder(
  FileSystem fileSystem,
  String folder,
) async {
  const supportPath = '/home/user/.openra';
  final modVersion = TestUtils.generateMod().version;
  final folderPath = path.join(supportPath, folder, 'test', modVersion);
  fileSystem.directory(folderPath).createSync(recursive: true);
  return folderPath;
}

ProcessModFoldersService _createService({
  required FileSystem fileSystem,
  required String platformOperatingSystem,
  required LaunchProcessStarter starter,
  Set<String> supportPaths = const {'/home/user/.openra'},
  ErrorReporter reportError = defaultErrorReporter,
}) {
  return ProcessModFoldersService(
    supportDirService: _FakeSupportDirService(TaskEither.right({
      ...supportPaths.map(fileSystem.directory),
    })),
    fileSystem: fileSystem,
    platform: FakePlatform(operatingSystem: platformOperatingSystem),
    starter: starter,
    reportError: reportError,
  );
}

LaunchProcessStarter _recordingStarter(List<List<String>> started) {
  return _FakeProcessStarter((executable, arguments) async {
    started.add([executable, ...arguments]);
  });
}

class _FakeSupportDirService implements SupportDirService {
  final TaskEither<FileSystemFailure, Set<Directory>> _result;

  _FakeSupportDirService(this._result);

  @override
  TaskEither<FileSystemFailure, Set<Directory>> getAllSupportDirs() => _result;
}

class _FakeProcessStarter implements LaunchProcessStarter {
  final Future<void> Function(String executable, List<String> arguments)
      _onStart;

  _FakeProcessStarter(this._onStart);

  @override
  Future<void> start(String executable, List<String> arguments) async {
    await _onStart(executable, arguments);
  }
}

class _ThrowingProcessStarter implements LaunchProcessStarter {
  @override
  Future<void> start(String executable, List<String> arguments) async {
    throw Exception('boom');
  }
}
