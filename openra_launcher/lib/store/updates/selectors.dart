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

/// Whether a release update should be advertised for [mod].
///
/// True when a latest release exists whose version differs from
/// `mod.version`, unless this install is the latest playtest and that
/// playtest is newer than the latest release (i.e. the user is already
/// running something newer than the release being offered).
bool selectHasReleaseUpdate(AppState state, Mod mod) {
  final latestRelease = selectLatestReleaseForMod(state, mod.id);
  if (latestRelease == null || latestRelease.version == mod.version) {
    return false;
  }

  if (_isRunningNewerPlaytest(state, mod)) {
    return false;
  }

  return true;
}

/// Whether a playtest update should be advertised for [mod].
///
/// True when:
/// - a latest playtest exists,
/// - its version differs from `mod.version`,
/// - it is newer than the latest release (or no release exists), so an
///   outdated playtest is never advertised over a newer stable, and
/// - no other installed copy of the same mod id already has that exact
///   playtest version installed.
bool selectHasPlaytestUpdate(AppState state, Mod mod) {
  final latestPlaytest = selectLatestPlaytestForMod(state, mod.id);
  if (latestPlaytest == null || latestPlaytest.version == mod.version) {
    return false;
  }

  final latestRelease = selectLatestReleaseForMod(state, mod.id);
  if (latestRelease != null && latestPlaytest.id <= latestRelease.id) {
    return false;
  }

  return !_isVersionInstalledByAnyCopy(state, mod.id, latestPlaytest.version);
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

bool _isRunningNewerPlaytest(AppState state, Mod mod) {
  final latestPlaytest = selectLatestPlaytestForMod(state, mod.id);
  if (latestPlaytest == null || latestPlaytest.version != mod.version) {
    return false;
  }

  final latestRelease = selectLatestReleaseForMod(state, mod.id);
  return latestRelease == null || latestPlaytest.id > latestRelease.id;
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
  return releases
      .where((release) =>
          !_isVersionInstalledByAnyCopy(state, release.modId, release.version))
      .toSet();
}
