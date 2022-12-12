import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:openra_launcher/data/models/app_release_model.dart';
import 'package:openra_launcher/domain/entities/app_release.dart';
import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/domain/entities/release.dart';
import 'package:openra_launcher/store/actions.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/selectors.dart';
import 'package:openra_launcher/usecases/get_installed_mods.dart';
import 'package:openra_launcher/usecases/use_case.abstract.dart';
import 'package:openra_launcher/utils/platform_utils.dart';
import 'package:openra_launcher/utils/release_utils.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createMiddleware(GetInstalledMods getInstalledMods) {
  return [
    TypedMiddleware<AppState, LoadModsAction>(
        _createLoadMods(getInstalledMods)),
    TypedMiddleware<AppState, ReloadModsAction>(
        _createReloadMods(getInstalledMods)),
    TypedMiddleware<AppState, LoadUpdatesAction>(_createLoadModUpdates()),
    TypedMiddleware<AppState, LoadAppUpdateAction>(_createLoadAppUpdate()),
  ];
}

Middleware<AppState> _createLoadMods(GetInstalledMods getInstalledMods) {
  return (Store<AppState> store, action, NextDispatcher next) {
    _loadAllMods(getInstalledMods, store, true);
    next(action);
  };
}

Middleware<AppState> _createReloadMods(GetInstalledMods getInstalledMods) {
  return (Store<AppState> store, action, NextDispatcher next) {
    // NOTE: Add artificial delay to give the user feedback that something is going on
    Timer(const Duration(milliseconds: 300), () {
      _loadAllMods(getInstalledMods, store, false);
    });

    next(action);
  };
}

Middleware<AppState> _createLoadAppUpdate() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (!store.state.autoCheckAppUpdates) {
      return;
    }

    ReleaseUtils.fetchLatestAppRelease().then((rawResponse) async {
      final packageInfo = await PlatformUtils.getPackageInfo();
      final responseBody = jsonDecode(rawResponse.body) as Map<String, dynamic>;

      if (!responseBody.containsKey('message')) {
        AppRelease release = AppReleaseModel.fromJson(responseBody);

        if (release.version != packageInfo.version) {
          store.dispatch(AppUpdateLoadedAction(release));
        } else {
          store.dispatch(AppUpdateEmptyAction());
        }
      } else {
        store.dispatch(AppUpdateEmptyAction());
      }
    }).catchError((e) {
      store.dispatch(AppUpdateErrorAction());
      debugPrint('Error fetching app updates: ${e.toString()}');
    });

    next(action);
  };
}

Middleware<AppState> _createLoadModUpdates() {
  // TODO: Break this up or reduce the length somehow
  return (Store<AppState> store, action, NextDispatcher next) {
    if (store.state.mods.isEmpty) {
      // NOTE: Add artificial delay to give the user feedback that something is going on
      Timer(const Duration(milliseconds: 300), () {
        store.dispatch(UpdatesEmptyAction());
      });

      next(action);
      return;
    }

    final uniqueModIds = selectUniqueModIds(store.state);

    ReleaseUtils.fetchLatestReleases(uniqueModIds).then((releases) {
      Map<String, Release> perModReleases = {};
      Map<String, Release> perModPlaytests = {};

      for (final modId in uniqueModIds) {
        final latestReleaseSet =
            ReleaseUtils.getLatestReleaseForMod(modId, releases);

        if (latestReleaseSet.isNotEmpty) {
          perModReleases[modId] = latestReleaseSet.first;
        }

        final latestPlaytestSet =
            ReleaseUtils.getLatestPlaytestForMod(modId, releases);

        if (latestPlaytestSet.isNotEmpty) {
          perModPlaytests[modId] = latestPlaytestSet.first;
        }
      }

      Set<Mod> mods = store.state.mods.map((mod) {
        if (!perModReleases.containsKey(mod.id) &&
            !perModPlaytests.containsKey(mod.id)) {
          return mod;
        }

        var isRelease = false;
        var isPlaytest = false;
        var hasRelease = false;
        var hasPlaytest = false;

        if (perModReleases.containsKey(mod.id)) {
          if (perModReleases[mod.id]?.version == mod.version) {
            perModReleases.remove(mod.id);
            isRelease = true;
          } else {
            hasRelease = true;
          }
        }

        if (perModPlaytests.containsKey(mod.id)) {
          if (perModPlaytests[mod.id]?.version == mod.version) {
            perModPlaytests.remove(mod.id);
            isPlaytest = true;
          } else {
            hasPlaytest = true;
          }
        }

        return mod.copyWith(
          isRelease: isRelease,
          isPlaytest: isPlaytest,
          hasRelease: hasRelease,
          hasPlaytest: hasPlaytest,
        );
      }).toSet();

      store.dispatch(ModsLoadedAction(mods));

      Set<Release> allPerModReleses =
          perModReleases.values.toSet().union(perModPlaytests.values.toSet());
      store.dispatch(allPerModReleses.isNotEmpty
          ? UpdatesLoadedAction(allPerModReleses)
          : UpdatesEmptyAction());
    }).catchError((e) {
      debugPrint('Error fetching updates: ${e.toString()}');

      store.dispatch(ModsLoadedAction(store.state.mods.map((mod) {
        return mod.copyWith(
          hasRelease: false,
          hasPlaytest: false,
        );
      }).toSet()));

      store.dispatch(UpdatesErrorAction());
    });

    next(action);
  };
}

_loadAllMods(GetInstalledMods getInstalledMods, Store<AppState> store,
    bool checkForUpdates) {
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
