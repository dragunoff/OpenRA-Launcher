import 'dart:async';

import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/selectors.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:openra_launcher/features/updates/domain/use_cases/get_latest_mod_releases.dart';
import 'package:redux/redux.dart';

Middleware<AppState> createLoadModUpdates(
  GetLatestModReleases getLatestModReleases,
) {
  // TODO: Break this up or reduce the complexity
  return (Store<AppState> store, action, NextDispatcher next) {
    // No installed mods so nothing much to do here
    if (store.state.mods.isEmpty) {
      // NOTE: Add artificial delay to give the user
      // feedback that something is going on
      Timer(const Duration(milliseconds: 300), () {
        store.dispatch(UpdatesEmptyAction());
      });

      next(action);
      return;
    }

    final uniqueInstalledModIds = selectUniqueInstalledModIds(store.state);

    getLatestModReleases(Params(mods: uniqueInstalledModIds)).then((releases) {
      releases.fold((failure) {
        store.dispatch(UpdatesEmptyAction());
        store.dispatch(UpdatesErrorAction());
      }, (releases) {
        // Compile a list of releases and playtests
        Map<String, Release> perModReleases = {};
        Map<String, Release> perModPlaytests = {};

        for (final modId in uniqueInstalledModIds) {
          final latestReleaseSet = _getLatestReleaseForMod(modId, releases);

          if (latestReleaseSet.isNotEmpty) {
            perModReleases[modId] = latestReleaseSet.first;
          }

          final latestPlaytestSet = _getLatestPlaytestForMod(modId, releases);

          if (latestPlaytestSet.isNotEmpty) {
            perModPlaytests[modId] = latestPlaytestSet.first;
          }
        }

        Set<Release> allPerModReleases =
            perModReleases.values.toSet().union(perModPlaytests.values.toSet());

        store.dispatch(allPerModReleases.isNotEmpty
            ? UpdatesLoadedAction(allPerModReleases)
            : UpdatesEmptyAction());
      });
    });

    next(action);
  };
}

Set<Release> _getLatestReleaseForMod(String modId, Set<Release> releases) {
  return releases.where((r) => r.modId == modId && !r.isPlaytest).toSet();
}

Set<Release> _getLatestPlaytestForMod(String modId, Set<Release> releases) {
  return releases.where((r) => r.modId == modId && r.isPlaytest).toSet();
}
