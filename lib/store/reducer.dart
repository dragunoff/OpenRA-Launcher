// We create the State reducer by combining many smaller reducers into one!
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/reducer.dart';
import 'package:openra_launcher/store/app_update/reducer.dart';
import 'package:openra_launcher/store/auto_check_app_updates/reducer.dart';
import 'package:openra_launcher/store/favorite_mods/reducer.dart';
import 'package:openra_launcher/store/hidden_mods/reducer.dart';
import 'package:openra_launcher/store/mods_list_status/reducer.dart';
import 'package:openra_launcher/store/show_dev_mods/reducer.dart';
import 'package:openra_launcher/store/show_hidden_mods/reducer.dart';
import 'package:openra_launcher/store/updates/reducer.dart';
import 'package:openra_launcher/store/mod_database_status/reducer.dart';
import 'package:openra_launcher/store/server_list/reducer.dart';
import 'package:openra_launcher/store/server_list_status/reducer.dart';
import 'package:openra_launcher/store/server_status_filter/reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    mods: modsReducer(state.mods, action),
    modDatabase: modDatabaseReducer(state.modDatabase, action),
    servers: serverListReducer(state.servers, action),
    favoriteMods: favoriteModsReducer(state.favoriteMods, action),
    hiddenMods: hiddenModsReducer(state.hiddenMods, action),
    modsListStatus: modsListStatusReducer(state.modsListStatus, action),
    modDatabaseStatus: modDatabaseStatusReducer(
      state.modDatabaseStatus,
      action,
    ),
    serverListStatus: serverListStatusReducer(state.serverListStatus, action),
    autoCheckAppUpdates: autoCheckAppUpdatesReducer(
      state.autoCheckAppUpdates,
      action,
    ),
    showDevMods: showDevModsReducer(state.showDevMods, action),
    showHiddenMods: showHiddenModsReducer(state.showHiddenMods, action),
    serverStatusFilter: serverStatusFilterReducer(
      state.serverStatusFilter,
      action,
    ),
    appRelease: appUpdateReducer(state.appRelease, action),
  );
}
