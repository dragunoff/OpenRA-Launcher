import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/app_update/actions.dart';
import 'package:openra_launcher/store/app_update/middleware.dart';
import 'package:openra_launcher/store/mods/actions.dart';
import 'package:openra_launcher/store/mods/middleware.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:openra_launcher/store/updates/middleware.dart';
import 'package:openra_launcher/usecases/get_installed_mods.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createMiddleware(GetInstalledMods getInstalledMods) {
  return [
    TypedMiddleware<AppState, LoadModsAction>(createLoadMods(getInstalledMods)),
    TypedMiddleware<AppState, ReloadModsAction>(
        createReloadMods(getInstalledMods)),
    TypedMiddleware<AppState, LoadUpdatesAction>(createLoadModUpdates()),
    TypedMiddleware<AppState, LoadAppUpdateAction>(createLoadAppUpdate()),
  ];
}
