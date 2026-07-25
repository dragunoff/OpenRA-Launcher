import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/store/app_state.dart';

Set<Release> selectReleaseUpdates(AppState state) {
  return state.releases.where((release) => !release.isPlaytest).toSet();
}

Set<Release> selectPlaytestUpdates(AppState state) {
  return state.releases.where((release) => release.isPlaytest).toSet();
}

Release? selectLatestReleaseForMod(AppState state, String modId) {
  final releases =
      selectReleaseUpdates(state).where((release) => release.modId == modId);

  if (releases.isEmpty) {
    return null;
  }

  return releases.reduce((value, element) {
    return element.id > value.id ? element : value;
  });
}

Release? selectLatestPlaytestForMod(AppState state, String modId) {
  final playtests =
      selectPlaytestUpdates(state).where((release) => release.modId == modId);

  if (playtests.isEmpty) {
    return null;
  }

  return playtests.reduce((value, element) {
    return element.id > value.id ? element : value;
  });
}

ModReleaseType selectCurrentModReleaseType(AppState state, Mod mod) {
  final latestRelease = selectLatestReleaseForMod(state, mod.id);
  if (latestRelease != null && latestRelease.version == mod.version) {
    return ModReleaseType.release;
  }

  final latestPlaytest = selectLatestPlaytestForMod(state, mod.id);
  if (latestPlaytest != null && latestPlaytest.version == mod.version) {
    return ModReleaseType.playtest;
  }

  return ModReleaseType.none;
}

bool selectHasReleaseUpdate(AppState state, Mod mod) {
  final latestRelease = selectLatestReleaseForMod(state, mod.id);
  return latestRelease != null && latestRelease.version != mod.version;
}

bool selectHasPlaytestUpdate(AppState state, Mod mod) {
  final latestPlaytest = selectLatestPlaytestForMod(state, mod.id);
  if (latestPlaytest == null || latestPlaytest.version == mod.version) {
    return false;
  }

  return !state.mods.any((installed) =>
      installed.id == mod.id && installed.version == latestPlaytest.version);
}
