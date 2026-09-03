import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:xdg_directories/xdg_directories.dart' as xdg;

class InstalledModsFixtureGenerator {
  Future<void> createFixtures({
    String? supportDirPath,
    bool includeDevVersions = true,
    bool includeInvalidEntries = true,
  }) async {
    final root = Directory(_resolveSupportDirPath(supportDirPath)).absolute;
    final metadataDir = Directory(path.join(root.path, 'ModMetadata'));
    final launchTargetsDir = Directory(path.join(root.path, 'LaunchTargets'));

    metadataDir.createSync(recursive: true);
    launchTargetsDir.createSync(recursive: true);

    final fixtures = <_FixtureManifest>[
      _FixtureManifest(
        filename: 'ra-release-20210321.yaml',
        id: 'ra',
        version: 'release-20210321',
        title: 'Red Alert',
        launchPath: path.join(launchTargetsDir.path, 'ra-release-20210321.sh'),
        launchArgs: 'Game.Mod=ra',
        isValid: true,
      ),
      _FixtureManifest(
        filename: 'cnc-release-20210321.yaml',
        id: 'cnc',
        version: 'release-20210321',
        title: 'Tiberian Dawn',
        launchPath: path.join(launchTargetsDir.path, 'cnc-release-20210321.sh'),
        launchArgs: 'Game.Mod=cnc',
        isValid: true,
      ),
      _FixtureManifest(
        filename: 'd2k-release-20210321.yaml',
        id: 'd2k',
        version: 'release-20210321',
        title: 'Dune 2000',
        launchPath: path.join(launchTargetsDir.path, 'd2k-release-20210321.sh'),
        launchArgs: 'Game.Mod=d2k',
        isValid: true,
      ),
      _FixtureManifest(
        filename: 'hv-release-20231010.yaml',
        id: 'hv',
        version: 'release-20231010',
        title: 'OpenHV',
        launchPath: path.join(launchTargetsDir.path, 'hv-release-20231010.sh'),
        launchArgs: 'Game.Mod=hv',
        isValid: true,
      ),
      _FixtureManifest(
        filename: 'sp-release-20230802.yaml',
        id: 'sp',
        version: 'release-20230802',
        title: 'Shattered Paradise',
        launchPath: path.join(launchTargetsDir.path, 'sp-release-20230802.sh'),
        launchArgs: 'Game.Mod=sp',
        isValid: true,
      ),
      _FixtureManifest(
        filename: 'cnc-release-20250330.yaml',
        id: 'cnc',
        version: 'release-20250330',
        title: 'Tiberian Dawn',
        launchPath: path.join(launchTargetsDir.path, 'cnc-release-20250330.sh'),
        launchArgs: 'Game.Mod=cnc',
        isValid: true,
      ),
      _FixtureManifest(
        filename: 'ra-playtest-20260222.yaml',
        id: 'ra',
        version: 'playtest-20260222',
        title: 'Red Alert',
        launchPath: path.join(launchTargetsDir.path, 'ra-playtest-20260222.sh'),
        launchArgs: 'Game.Mod=ra',
        isValid: true,
      ),
      _FixtureManifest(
        filename: 'fnw-v1.0.yaml',
        id: 'fnw',
        version: 'v1.0',
        title: 'Fractured Realms',
        launchPath: path.join(launchTargetsDir.path, 'fnw-v1.0.sh'),
        launchArgs: 'Game.Mod=fnw',
        isValid: true,
      ),
      if (includeDevVersions) ...[
        _FixtureManifest(
          filename: 'ts-{DEV_VERSION}.yaml',
          id: 'ts',
          version: '{DEV_VERSION}',
          title: 'Tiberian Sun',
          launchPath: path.join(launchTargetsDir.path, 'ts-{DEV_VERSION}.sh'),
          launchArgs: 'Game.Mod=ts',
          isValid: true,
        ),
        _FixtureManifest(
          filename: 'hv-{DEV_VERSION}.yaml',
          id: 'hv',
          version: '{DEV_VERSION}',
          title: 'OpenHV',
          launchPath: path.join(launchTargetsDir.path, 'hv-{DEV_VERSION}.sh'),
          launchArgs: 'Game.Mod=hv',
          isValid: true,
        ),
        _FixtureManifest(
          filename: 'sp-{DEV_VERSION}.yaml',
          id: 'sp',
          version: '{DEV_VERSION}',
          title: 'Shattered Paradise',
          launchPath: path.join(launchTargetsDir.path, 'sp-{DEV_VERSION}.sh'),
          launchArgs: 'Game.Mod=sp',
          isValid: true,
        ),
      ],
      if (includeInvalidEntries)
        _FixtureManifest(
          filename: 'invalid-missing-launchpath.yaml',
          id: 'cnc',
          version: 'broken',
          title: 'Broken C&C',
          launchPath: path.join(launchTargetsDir.path, 'broken.sh'),
          launchArgs: 'Game.Mod=cnc',
          isValid: false,
          content:
              'Registration:\n  Id: cnc\n  Version: broken\n  Title: Broken C&C\n  LaunchArgs: Game.Mod=cnc\n',
        ),
      if (includeInvalidEntries)
        _FixtureManifest(
          filename: 'bogus-filename.yaml',
          id: 'd2k',
          version: 'release-20210321',
          title: 'Dune 2000',
          launchPath: path.join(
            launchTargetsDir.path,
            'd2k-release-20210321.sh',
          ),
          launchArgs: 'Game.Mod=d2k',
          isValid: false,
        ),
      if (includeInvalidEntries)
        _FixtureManifest(
          filename: 'invalid-empty-id.yaml',
          id: '',
          version: 'release-20210321',
          title: 'Red Alert',
          launchPath: path.join(launchTargetsDir.path, 'ra-empty-id.sh'),
          launchArgs: 'Game.Mod=ra',
          isValid: false,
        ),
      if (includeInvalidEntries)
        _FixtureManifest(
          filename: 'invalid-empty-version.yaml',
          id: 'ra',
          version: '',
          title: 'Red Alert',
          launchPath: path.join(launchTargetsDir.path, 'ra-empty-version.sh'),
          launchArgs: 'Game.Mod=ra',
          isValid: false,
        ),
      if (includeInvalidEntries)
        _FixtureManifest(
          filename: 'invalid-empty-title.yaml',
          id: 'ra',
          version: 'release-20210321',
          title: '',
          launchPath: path.join(launchTargetsDir.path, 'ra-empty-title.sh'),
          launchArgs: 'Game.Mod=ra',
          isValid: false,
        ),
      if (includeInvalidEntries)
        _FixtureManifest(
          filename: 'invalid-empty-launchargs.yaml',
          id: 'ra',
          version: 'release-20210321',
          title: 'Red Alert',
          launchPath: path.join(
            launchTargetsDir.path,
            'ra-empty-launchargs.sh',
          ),
          launchArgs: '',
          isValid: false,
        ),
      if (includeInvalidEntries)
        _FixtureManifest(
          filename: 'invalid-dll-launchpath.yaml',
          id: 'ra',
          version: 'release-20210321',
          title: 'Red Alert',
          launchPath: '/home/user/OpenRA/OpenRA.dll',
          launchArgs: 'Game.Mod=ra',
          isValid: false,
        ),
      if (includeInvalidEntries)
        _FixtureManifest(
          filename: 'invalid-no-version.yaml',
          id: 'ra',
          version: '',
          title: 'Red Alert',
          launchPath: path.join(launchTargetsDir.path, 'ra-no-version.sh'),
          launchArgs: 'Game.Mod=ra',
          isValid: false,
          content:
              'Registration:\n  Id: ra\n  Title: Red Alert\n  LaunchPath: ${path.join(launchTargetsDir.path, 'ra-no-version.sh')}\n  LaunchArgs: Game.Mod=ra\n',
        ),
      if (includeInvalidEntries)
        _FixtureManifest(
          filename: 'invalid-no-title.yaml',
          id: 'ra',
          version: 'release-20210321',
          title: '',
          launchPath: path.join(launchTargetsDir.path, 'ra-no-title.sh'),
          launchArgs: 'Game.Mod=ra',
          isValid: false,
          content:
              'Registration:\n  Id: ra\n  Version: release-20210321\n  LaunchPath: ${path.join(launchTargetsDir.path, 'ra-no-title.sh')}\n  LaunchArgs: Game.Mod=ra\n',
        ),
      if (includeInvalidEntries)
        _FixtureManifest(
          filename: 'invalid-no-launchargs.yaml',
          id: 'ra',
          version: 'release-20210321',
          title: 'Red Alert',
          launchPath: path.join(launchTargetsDir.path, 'ra-no-launchargs.sh'),
          launchArgs: '',
          isValid: false,
          content:
              'Registration:\n  Id: ra\n  Version: release-20210321\n  Title: Red Alert\n  LaunchPath: ${path.join(launchTargetsDir.path, 'ra-no-launchargs.sh')}\n',
        ),
      if (includeInvalidEntries)
        _FixtureManifest(
          filename: 'invalid-missing-launchfile.yaml',
          id: 'ra',
          version: 'release-20210321',
          title: 'Red Alert',
          launchPath: path.join(
            launchTargetsDir.path,
            'ra-missing-launchfile.sh',
          ),
          launchArgs: 'Game.Mod=ra',
          isValid: false,
        ),
    ];

    for (final fixture in fixtures) {
      final manifestFile = File(path.join(metadataDir.path, fixture.filename));
      manifestFile.writeAsStringSync(
        fixture.content ?? _buildManifestContent(fixture),
      );

      if (fixture.isValid) {
        File(fixture.launchPath).createSync(recursive: true);
      }
    }

    stdout.writeln('Created installed-mod fixtures in ${root.path}');
  }

  Future<void> cleanupFixtures({String? supportDirPath}) async {
    final root = Directory(_resolveSupportDirPath(supportDirPath)).absolute;
    final metadataDir = Directory(path.join(root.path, 'ModMetadata'));
    final launchTargetsDir = Directory(path.join(root.path, 'LaunchTargets'));

    final manifestFiles = <String>[
      'ra-release-20210321.yaml',
      'cnc-release-20210321.yaml',
      'd2k-release-20210321.yaml',
      'hv-release-20231010.yaml',
      'sp-release-20230802.yaml',
      'cnc-release-20250330.yaml',
      'ra-playtest-20260222.yaml',
      'fnw-v1.0.yaml',
      'ts-{DEV_VERSION}.yaml',
      'hv-{DEV_VERSION}.yaml',
      'sp-{DEV_VERSION}.yaml',
      'invalid-missing-launchpath.yaml',
      'bogus-filename.yaml',
      'invalid-empty-id.yaml',
      'invalid-empty-version.yaml',
      'invalid-empty-title.yaml',
      'invalid-empty-launchargs.yaml',
      'invalid-dll-launchpath.yaml',
      'invalid-no-version.yaml',
      'invalid-no-title.yaml',
      'invalid-no-launchargs.yaml',
      'invalid-missing-launchfile.yaml',
    ];

    final launchFiles = <String>[
      path.join(launchTargetsDir.path, 'ra-release-20210321.sh'),
      path.join(launchTargetsDir.path, 'cnc-release-20210321.sh'),
      path.join(launchTargetsDir.path, 'd2k-release-20210321.sh'),
      path.join(launchTargetsDir.path, 'hv-release-20231010.sh'),
      path.join(launchTargetsDir.path, 'sp-release-20230802.sh'),
      path.join(launchTargetsDir.path, 'cnc-release-20250330.sh'),
      path.join(launchTargetsDir.path, 'ra-playtest-20260222.sh'),
      path.join(launchTargetsDir.path, 'fnw-v1.0.sh'),
      path.join(launchTargetsDir.path, 'ts-{DEV_VERSION}.sh'),
      path.join(launchTargetsDir.path, 'hv-{DEV_VERSION}.sh'),
      path.join(launchTargetsDir.path, 'sp-{DEV_VERSION}.sh'),
    ];

    for (final fileName in manifestFiles) {
      final file = File(path.join(metadataDir.path, fileName));
      if (file.existsSync()) {
        file.deleteSync();
      }
    }

    for (final filePath in launchFiles) {
      final file = File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }

    if (metadataDir.existsSync() && metadataDir.listSync().isEmpty) {
      metadataDir.deleteSync();
    }

    if (launchTargetsDir.existsSync() && launchTargetsDir.listSync().isEmpty) {
      launchTargetsDir.deleteSync();
    }

    stdout.writeln('Removed installed-mod fixtures from ${root.path}');
  }

  String _resolveSupportDirPath(String? supportDirPath) {
    if (supportDirPath != null && supportDirPath.isNotEmpty) {
      return Directory(supportDirPath).absolute.path;
    }

    final configHome = xdg.configHome.path;
    if (configHome.isNotEmpty) {
      return path.join(configHome, 'openra');
    }

    return path.join(Platform.environment['HOME'] ?? '.', '.config', 'openra');
  }

  String _buildManifestContent(_FixtureManifest fixture) {
    return '''Registration:
  Id: ${fixture.id}
  Version: ${fixture.version}
  Title: ${fixture.title}
  LaunchPath: ${fixture.launchPath}
  LaunchArgs: ${fixture.launchArgs}
''';
  }
}

class _FixtureManifest {
  const _FixtureManifest({
    required this.filename,
    required this.id,
    required this.version,
    required this.title,
    required this.launchPath,
    required this.launchArgs,
    required this.isValid,
    this.content,
  });

  final String filename;
  final String id;
  final String version;
  final String title;
  final String launchPath;
  final String launchArgs;
  final bool isValid;
  final String? content;
}
