// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:file/file.dart' as _i4;
import 'package:file/local.dart' as _i14;
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i5;
import 'package:openra_launcher/core/network/network_info_service.dart' as _i6;
import 'package:openra_launcher/core/platform/support_dir_service.dart' as _i8;
import 'package:openra_launcher/data/data_sources/installed_mods_data_source.dart'
    as _i9;
import 'package:openra_launcher/data/repositories/installed_mods_repository_impl.dart'
    as _i11;
import 'package:openra_launcher/domain/repositories/installed_mods_repository.abstract.dart'
    as _i10;
import 'package:openra_launcher/injection.dart' as _i13;
import 'package:openra_launcher/usecases/get_installed_mods.dart' as _i12;
import 'package:platform/platform.dart' as _i7;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  _i1.GetIt init(
      {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
    final gh = _i2.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i3.Client>(() => registerModule.httpClient);
    gh.lazySingleton<_i4.FileSystem>(() => registerModule.fileSystem);
    gh.lazySingleton<_i5.InternetConnectionChecker>(
        () => registerModule.internetConnectionChecker);
    gh.lazySingleton<_i6.NetworkInfoService>(
        () => _i6.NetworkInfoServiceImpl(gh<_i5.InternetConnectionChecker>()));
    gh.lazySingleton<_i7.Platform>(() => registerModule.platform);
    gh.lazySingleton<_i8.SupportDirService>(() => _i8.SupportDirServiceImpl(
        platform: gh<_i7.Platform>(), fileSystem: gh<_i4.FileSystem>()));
    gh.lazySingleton<_i9.InstalledModsDataSource>(() =>
        _i9.InstalledModsDataSourceImpl(
            fileSystem: gh<_i4.FileSystem>(),
            supportDirService: gh<_i8.SupportDirService>()));
    gh.lazySingleton<_i10.InstalledModsRepository>(() =>
        _i11.InstalledModsRepositoryImpl(
            dataSource: gh<_i9.InstalledModsDataSource>()));
    gh.lazySingleton<_i12.GetInstalledMods>(
        () => _i12.GetInstalledMods(gh<_i10.InstalledModsRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i13.RegisterModule {
  @override
  _i5.InternetConnectionChecker get internetConnectionChecker =>
      _i5.InternetConnectionChecker();
  @override
  _i7.LocalPlatform get platform => _i7.LocalPlatform();
  @override
  _i14.LocalFileSystem get fileSystem => _i14.LocalFileSystem();
}
