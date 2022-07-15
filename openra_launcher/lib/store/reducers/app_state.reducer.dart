// We create the State reducer by combining many smaller reducers into one!
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/reducers/app_update.reducer.dart';
import 'package:openra_launcher/store/reducers/auto_check_app_updates.reducer%20copy.dart';
import 'package:openra_launcher/store/reducers/favorite_mods.reducer.dart';
import 'package:openra_launcher/store/reducers/mods_list_status.reducer.dart';
import 'package:openra_launcher/store/reducers/mods.reducer.dart';
import 'package:openra_launcher/store/reducers/updates.reducer.dart';
import 'package:openra_launcher/store/reducers/updates_list_status.reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    mods: modsReducer(state.mods, action),
    releases: updatesReducer(state.releases, action),
    favoriteMods: favoriteModsReducer(state.favoriteMods, action),
    modsListStatus: modsListStatusReducer(state.modsListStatus, action),
    updatesListStatus:
        updatesListStatusReducer(state.updatesListStatus, action),
    autoCheckAppUpdates:
        autoCheckAppUpdatesReducer(state.autoCheckAppUpdates, action),
    appRelease: appUpdateReducer(state.appRelease, action),
  );
}
