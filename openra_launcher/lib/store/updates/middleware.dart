import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/domain/entities/release.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/mods/actions.dart';
import 'package:openra_launcher/store/mods/selectors.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:openra_launcher/utils/release_utils.dart';
import 'package:redux/redux.dart';

Middleware<AppState> createLoadModUpdates() {
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
