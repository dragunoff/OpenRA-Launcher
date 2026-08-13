import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';

abstract class ModLaunchService {
  Future<void> launch(Mod mod);
}

abstract class LaunchProcessStarter {
  Future<void> start(String executable, List<String> arguments);
}

@LazySingleton(as: LaunchProcessStarter)
class ProcessStarter implements LaunchProcessStarter {
  @override
  Future<void> start(String executable, List<String> arguments) async {
    await Process.start(
      executable,
      arguments,
      runInShell: true,
      mode: ProcessStartMode.detached,
    );
  }
}

@LazySingleton(as: ModLaunchService)
class ProcessModLaunchService implements ModLaunchService {
  final LaunchProcessStarter starter;

  ProcessModLaunchService({required this.starter});

  @override
  Future<void> launch(Mod mod) async {
    try {
      await starter.start(mod.launchPath, mod.launchArgs);
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'installed_mods',
          context: ErrorDescription('launching mod ${mod.title}'),
        ),
      );

      Error.throwWithStackTrace(
        ModLaunchException(mod: mod, cause: error),
        stackTrace,
      );
    }
  }
}

class ModLaunchException implements Exception {
  ModLaunchException({required this.mod, required this.cause});

  final Mod mod;
  final Object cause;

  @override
  String toString() => 'Failed to launch mod ${mod.id}: $cause';
}
