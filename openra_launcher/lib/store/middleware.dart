import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/app_update/actions.dart';
import 'package:openra_launcher/store/app_update/middleware.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:openra_launcher/store/installed_mods/middleware.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:openra_launcher/store/updates/middleware.dart';
import 'package:openra_launcher/features/installed_mods/use_cases/get_installed_mods.dart';
import 'package:openra_launcher/features/updates/use_cases/get_latest_mod_releases.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createMiddleware({
  required GetInstalledMods getInstalledMods,
  required GetLatestModReleases getLatestModReleases,
}) {
  return [
    TypedMiddleware<AppState, LoadModsAction>(createLoadMods(getInstalledMods))
        .call,
    TypedMiddleware<AppState, ReloadModsAction>(
            createReloadMods(getInstalledMods))
        .call,
    TypedMiddleware<AppState, LoadUpdatesAction>(
            createLoadModUpdates(getLatestModReleases))
        .call,
    TypedMiddleware<AppState, LoadAppUpdateAction>(createLoadAppUpdate()).call,
  ];
}
