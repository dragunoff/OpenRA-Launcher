import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/mods/actions.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:openra_launcher/usecases/get_installed_mods.dart';
import 'package:openra_launcher/usecases/use_case.abstract.dart';
import 'package:redux/redux.dart';

Middleware<AppState> createLoadMods(GetInstalledMods getInstalledMods) {
  return (Store<AppState> store, action, NextDispatcher next) {
    _loadAllMods(getInstalledMods, store, true);
    next(action);
  };
}

Middleware<AppState> createReloadMods(GetInstalledMods getInstalledMods) {
  return (Store<AppState> store, action, NextDispatcher next) {
    // NOTE: Add artificial delay to give the user
    // feedback that something is going on
    Timer(const Duration(milliseconds: 300), () {
      _loadAllMods(getInstalledMods, store, false);
    });

    next(action);
  };
}

_loadAllMods(
  GetInstalledMods getInstalledMods,
  Store<AppState> store,
  bool checkForUpdates,
) {
  getInstalledMods(NoParams()).then(
    (mods) {
      mods.fold(
        (failure) {
          store.dispatch(ModsErrorAction());
          store.dispatch(UpdatesEmptyAction());
        },
        (mods) {
          if (mods.isEmpty) {
            store.dispatch(ModsEmptyAction());
            store.dispatch(UpdatesEmptyAction());

            return;
          }

          final oldMods = Set.from(store.state.mods);

          store.dispatch(ModsLoadedAction(mods));

          if (checkForUpdates || !setEquals(mods, oldMods)) {
            store.dispatch(LoadUpdatesAction());
          }
        },
      );
    },
  );
}
