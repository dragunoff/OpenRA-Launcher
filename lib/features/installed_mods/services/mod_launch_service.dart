import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/core/error/error_reporter.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';

abstract class ModLaunchService {
  TaskEither<PlatformFailure, Unit> launch(Mod mod);
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
  final ErrorReporter reportError;

  ProcessModLaunchService({
    required this.starter,
    this.reportError = defaultErrorReporter,
  });

  @override
  TaskEither<PlatformFailure, Unit> launch(Mod mod) {
    return TaskEither.tryCatch(() async {
      await starter.start(mod.launchPath, mod.launchArgs);

      return unit;
    }, (error, stackTrace) {
      reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'installed_mods',
          context: ErrorDescription('launching mod ${mod.title}'),
        ),
      );

      return PlatformFailure(error.toString());
    });
  }
}
