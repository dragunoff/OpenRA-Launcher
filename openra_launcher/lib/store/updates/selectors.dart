import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/store/app_state.dart';

Set<Release> selectReleaseUpdates(AppState state) {
  return _allReleases(state).where((release) => !release.isPlaytest).toSet();
}

Set<Release> selectPlaytestUpdates(AppState state) {
  return _allReleases(state).where((release) => release.isPlaytest).toSet();
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

/// Returns the release type the installed [mod] version corresponds to.
///
/// - `release` when `mod.version` matches the latest non-playtest release.
/// - `playtest` otherwise when it matches the latest playtest.
/// - `none` when it matches neither.
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

/// Returns true when the mod is present in the loaded mod database, i.e. there
/// is a release (stable or playtest) recorded for [modId].
bool selectIsModSupported(AppState state, String modId) {
  return _allReleases(state).any((release) => release.modId == modId);
}

/// Releases that are not installed by any copy of their mod.
Set<Release> selectAvailableReleaseUpdates(AppState state) {
  return _filterInstalled(state, selectReleaseUpdates(state));
}

/// Playtests that are not installed by any copy of their mod.
Set<Release> selectAvailablePlaytestUpdates(AppState state) {
  return _filterInstalled(state, selectPlaytestUpdates(state));
}

int selectUpdatesCount(AppState state) {
  final availableUpdates = selectAvailableReleaseUpdates(state)
      .union(selectAvailablePlaytestUpdates(state));

  if (state.showHiddenMods) return availableUpdates.length;

  final hiddenModIds = state.mods
      .where((mod) => state.hiddenMods.contains(mod.key))
      .map((mod) => mod.id)
      .toSet();

  return availableUpdates
      .where((release) => !hiddenModIds.contains(release.modId))
      .length;
}

/// Flattens every stable and playtest release stored in the mod database.
Set<Release> _allReleases(AppState state) {
  Set<Release> releases = {};

  for (final info in state.modDatabase.mods.values) {
    if (info.stable != null) {
      releases.add(info.stable!);
    }
    if (info.playtest != null) {
      releases.add(info.playtest!);
    }
  }

  return releases;
}

bool _isVersionInstalledByAnyCopy(
  AppState state,
  String modId,
  String version,
) {
  return state.mods.any((installed) =>
      installed.id == modId && installed.version == version);
}

Set<Release> _filterInstalled(AppState state, Set<Release> releases) {
  final installedModIds = state.mods.map((mod) => mod.id).toSet();

  return releases
      .where((release) =>
          installedModIds.contains(release.modId) &&
          !_isVersionInstalledByAnyCopy(state, release.modId, release.version))
      .toSet();
}
