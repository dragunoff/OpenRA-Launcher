import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:openra_launcher/models/app_release.dart';
import 'package:openra_launcher/models/mod.dart';
import 'package:openra_launcher/models/release.dart';
import 'package:openra_launcher/store/actions.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/selectors.dart';
import 'package:openra_launcher/utils/platform_utils.dart';
import 'package:openra_launcher/utils/release_utils.dart';
import 'package:openra_launcher/utils/mod_utils.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createMiddleware() {
  return [
    TypedMiddleware<AppState, LoadModsAction>(_createLoadMods()),
    TypedMiddleware<AppState, ReloadModsAction>(_createReloadMods()),
    TypedMiddleware<AppState, LoadUpdatesAction>(_createLoadModUpdates()),
    TypedMiddleware<AppState, LoadAppUpdateAction>(_createLoadAppUpdate()),
  ];
}

Middleware<AppState> _createLoadMods() {
  return (Store<AppState> store, action, NextDispatcher next) {
    _loadAllMods(store, true);
    next(action);
  };
}

Middleware<AppState> _createReloadMods() {
  return (Store<AppState> store, action, NextDispatcher next) {
    // NOTE: Add artificial delay to give the user feedback that something is going on
    Timer(const Duration(milliseconds: 300), () {
      _loadAllMods(store, false);
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
      var packageInfo = await PlatformUtils.getPackageInfo();
      var responseBody = jsonDecode(rawResponse.body) as Map<String, dynamic>;

      if (!responseBody.containsKey('message')) {
        AppRelease release = AppRelease.fromResponse(responseBody);

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
    var uniqueModIds = selectUniqueModIds(store.state);

    ReleaseUtils.fetchLatestReleases(uniqueModIds).then((rawResponses) {
      Set<Release> releases = {};

      rawResponses.forEach((modId, response) {
        releases.addAll(ReleaseUtils.getReleasesFromResponse(modId, response));
      });

      Map<String, Release> perModReleases = {};
      Map<String, Release> perModPlaytests = {};

      for (var modId in uniqueModIds) {
        var latestReleaseSet =
            ReleaseUtils.getLatestReleaseForMod(modId, releases);

        if (latestReleaseSet.isNotEmpty) {
          perModReleases[modId] = latestReleaseSet.first;
        }

        var latestPlaytestSet =
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

_loadAllMods(Store<AppState> store, bool checkForUpdates) {
  ModUtils.loadAllMods().then(
    (mods) {
      if (mods.isEmpty) {
        store.dispatch(ModsEmptyAction());
        store.dispatch(UpdatesEmptyAction());
      }

      var oldMods = Set.from(store.state.mods);

      store.dispatch(ModsLoadedAction(mods));

      if (checkForUpdates || !setEquals(mods, oldMods)) {
        store.dispatch(LoadUpdatesAction());
      }
    },
  ).catchError((_) {
    store.dispatch(ModsErrorAction());
    store.dispatch(UpdatesEmptyAction());
  });
}
