import 'package:openra_launcher/features/app_update/domain/entities/app_release.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database.dart';

const _defaultServerStatusFilter = {
  GameServerStatus.waiting,
  GameServerStatus.playing,
};

enum DataStatus { initial, empty, loading, loaded, error }

class AppState {
  final Set<Mod> mods;
  final ModDatabase modDatabase;
  final List<GameServer> servers;
  final Set<String> favoriteMods;
  final Set<String> hiddenMods;
  final DataStatus modsListStatus;
  final DataStatus modDatabaseStatus;
  final DataStatus serverListStatus;
  final bool autoCheckAppUpdates;
  final bool showDevMods;
  final bool showHiddenMods;
  final Set<GameServerStatus> serverStatusFilter;
  final AppRelease? appRelease;

  AppState({
    this.mods = const {},
    this.modDatabase = const ModDatabase(mods: {}),
    this.servers = const [],
    this.favoriteMods = const {},
    this.hiddenMods = const {},
    this.modsListStatus = DataStatus.initial,
    this.modDatabaseStatus = DataStatus.initial,
    this.serverListStatus = DataStatus.initial,
    this.autoCheckAppUpdates = true,
    this.showDevMods = false,
    this.showHiddenMods = false,
    this.serverStatusFilter = _defaultServerStatusFilter,
    this.appRelease,
  });

  factory AppState.initial() => AppState();

  static AppState? fromJson(dynamic json) {
    if (json == null) return null;

    return AppState(
      favoriteMods: Set.from(json['favoriteMods'] ?? {}),
      hiddenMods: Set.from(json['hiddenMods'] ?? {}),
      autoCheckAppUpdates: json['autoCheckAppUpdates'] ?? true,
      showDevMods: json['showDevMods'] ?? false,
      showHiddenMods: json['showHiddenMods'] ?? false,
      serverStatusFilter: Set<GameServerStatus>.from(
        ((json['serverStatusFilter'] as List?) ??
                _defaultServerStatusFilter.map((s) => s.name).toList())
            .map((status) => GameServerStatus.values.byName(status as String)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoCheckAppUpdates': autoCheckAppUpdates,
      'showDevMods': showDevMods,
      'showHiddenMods': showHiddenMods,
      'favoriteMods': favoriteMods.toList(),
      'hiddenMods': hiddenMods.toList(),
      'serverStatusFilter': serverStatusFilter
          .map((status) => status.name)
          .toList(),
    };
  }
}
