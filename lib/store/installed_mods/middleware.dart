import 'dart:async';

import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:openra_launcher/features/installed_mods/domain/use_cases/get_installed_mods.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';
import 'package:redux/redux.dart';

Middleware<AppState> createLoadMods(GetInstalledMods getInstalledMods) {
  return (Store<AppState> store, action, NextDispatcher next) {
    _loadAllMods(getInstalledMods, store);
    next(action);
  };
}

Middleware<AppState> createReloadMods(GetInstalledMods getInstalledMods) {
  return (Store<AppState> store, action, NextDispatcher next) {
    // NOTE: Add artificial delay to give the user
    // feedback that something is going on
    Timer(const Duration(milliseconds: 300), () {
      _loadAllMods(getInstalledMods, store);
    });

    next(action);
  };
}

void _loadAllMods(GetInstalledMods getInstalledMods, Store<AppState> store) {
  getInstalledMods(NoParams()).run().then((mods) {
    mods.fold(
      (failure) {
        store.dispatch(ModsErrorAction());
      },
      (mods) {
        if (mods.isEmpty) {
          store.dispatch(ModsEmptyAction());

          return;
        }

        store.dispatch(ModsLoadedAction(mods));
      },
    );
  });
}
