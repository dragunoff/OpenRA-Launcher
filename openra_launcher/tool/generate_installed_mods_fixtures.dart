import 'dart:io';

import 'package:openra_launcher/tools/installed_mods_fixture_generator.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty || args.first == 'help' || args.first == '--help') {
    _printUsage();
    return;
  }

  final generator = InstalledModsFixtureGenerator();
  final command = args.first;
  final supportDirFlagIndex = args.indexOf('--support-dir');
  String? supportDirPath;

  if (supportDirFlagIndex != -1 && supportDirFlagIndex + 1 < args.length) {
    supportDirPath = args[supportDirFlagIndex + 1];
  }

  if (command == 'create') {
    await generator.createFixtures(supportDirPath: supportDirPath);
    return;
  }

  if (command == 'cleanup') {
    await generator.cleanupFixtures(supportDirPath: supportDirPath);
    return;
  }

  stderr.writeln('Unknown command: $command');
  _printUsage();
  exitCode = 64;
}

void _printUsage() {
  stdout.writeln(
      'Usage: dart run tool/generate_installed_mods_fixtures.dart <create|cleanup> [--support-dir <path>]');
}
