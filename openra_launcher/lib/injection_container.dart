import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:openra_launcher/core/network/network_info_service.dart';
import 'package:openra_launcher/core/platform/support_dir_service.dart';
import 'package:openra_launcher/data/data_sources/installed_mods_data_source.dart';
import 'package:openra_launcher/data/repositories/installed_mods_repository_impl.dart';
import 'package:openra_launcher/domain/repositories/installed_mods_repository.abstract.dart';
import 'package:openra_launcher/usecases/get_installed_mods.dart';
import 'package:platform/platform.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Use cases
  sl.registerLazySingleton(() => GetInstalledMods(sl()));

  // Repository
  sl.registerLazySingleton<InstalledModsRepository>(
    () => InstalledModsRepositoryImpl(
      dataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<InstalledModsDataSource>(
    () =>
        InstalledModsDataSourceImpl(supportDirService: sl(), fileSystem: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfoService>(
      () => NetworkInfoServiceImpl(sl()));
  sl.registerLazySingleton<SupportDirService>(
      () => SupportDirServiceImpl(platform: sl(), fileSystem: sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton<Platform>(() => const LocalPlatform());
  sl.registerLazySingleton<FileSystem>(() => const LocalFileSystem());
}
