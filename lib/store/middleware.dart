import 'package:openra_launcher/core/platform/get_package_info.dart';
import 'package:openra_launcher/core/version_service.dart';
import 'package:openra_launcher/features/app_update/use_cases/get_latest_app_release.dart';
import 'package:openra_launcher/features/installed_mods/domain/use_cases/get_installed_mods.dart';
import 'package:openra_launcher/features/server_browser/domain/use_cases/get_server_list.dart';
import 'package:openra_launcher/features/updates/domain/use_cases/get_mod_database.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/app_update/actions.dart';
import 'package:openra_launcher/store/app_update/middleware.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:openra_launcher/store/installed_mods/middleware.dart';
import 'package:openra_launcher/store/server_list/actions.dart';
import 'package:openra_launcher/store/server_list/middleware.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:openra_launcher/store/updates/middleware.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createMiddleware({
  required GetInstalledMods getInstalledMods,
  required GetModDatabase getModDatabase,
  required GetLatestAppRelease getLatestAppRelease,
  required GetPackageInfo getPackageInfo,
  required GetServerList getServerList,
  required VersionService versionService,
}) {
  return [
    TypedMiddleware<AppState, LoadModsAction>(
      createLoadMods(getInstalledMods),
    ).call,
    TypedMiddleware<AppState, ReloadModsAction>(
      createReloadMods(getInstalledMods),
    ).call,
    TypedMiddleware<AppState, LoadModDatabaseAction>(
      createLoadModDatabase(getModDatabase),
    ).call,
    TypedMiddleware<AppState, LoadAppUpdateAction>(
      createLoadAppUpdate(getLatestAppRelease, getPackageInfo, versionService),
    ).call,
    TypedMiddleware<AppState, LoadServerListAction>(
      createLoadServerList(getServerList),
    ).call,
    TypedMiddleware<AppState, ReloadServerListAction>(
      createReloadServerList(getServerList),
    ).call,
  ];
}
