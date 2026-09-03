import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:openra_launcher/core/error/error_reporter.dart';
import 'package:openra_launcher/injection.config.dart';
import 'package:platform/platform.dart';

final getIt = GetIt.instance;

@injectableInit
void configureDependencies() {
  getIt.init();
  getIt.registerLazySingleton<ErrorReporter>(() => defaultErrorReporter);
}

@module
abstract class RegisterModule {
  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker;

  @LazySingleton(as: Platform)
  LocalPlatform get platform;

  @LazySingleton(as: FileSystem)
  LocalFileSystem get fileSystem;
}
