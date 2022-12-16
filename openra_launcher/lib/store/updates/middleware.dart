import 'dart:async';

import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/domain/entities/release.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/mods/actions.dart';
import 'package:openra_launcher/store/mods/selectors.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:openra_launcher/usecases/get_latest_mod_releases.dart';
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
        // Discard all update-related info from mods
        store.dispatch(ModsLoadedAction(store.state.mods.map((mod) {
          return mod.copyWith(
            isRelease: false,
            isPlaytest: false,
            hasRelease: false,
            hasPlaytest: false,
          );
        }).toSet()));

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

        // Add update-related info to mods and
        // remove already installed updates
        Set<Mod> mods = store.state.mods.map((mod) {
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
            final playtestVersion = perModPlaytests[mod.id]?.version;

            if (playtestVersion == mod.version) {
              perModPlaytests.remove(mod.id);
              isPlaytest = true;
            } else {
              final isPlaytestInstalled = store.state.mods.any((installed) =>
                  installed.id == mod.id &&
                  installed.version == playtestVersion);

              hasPlaytest = !isPlaytestInstalled;
            }
          }

          return mod.copyWith(
            isRelease: isRelease,
            isPlaytest: isPlaytest,
            hasRelease: hasRelease,
            hasPlaytest: hasPlaytest,
          );
        }).toSet();

        // Update the store
        store.dispatch(ModsLoadedAction(mods));

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
