import 'package:openra_launcher/features/app_update/domain/entities/app_release.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database.dart';

enum ListStatus {
  initial,
  empty,
  loading,
  loaded,
  error,
}

class AppState {
  final Set<Mod> mods;
  final ModDatabase modDatabase;
  final Set<String> favoriteMods;
  final Set<String> hiddenMods;
  final ListStatus modsListStatus;
  final ListStatus updatesListStatus;
  final bool autoCheckAppUpdates;
  final bool showDevMods;
  final bool showHiddenMods;
  final AppRelease? appRelease;

  AppState({
    this.mods = const {},
    this.modDatabase = const ModDatabase(mods: {}),
    this.favoriteMods = const {},
    this.hiddenMods = const {},
    this.modsListStatus = ListStatus.initial,
    this.updatesListStatus = ListStatus.initial,
    this.autoCheckAppUpdates = true,
    this.showDevMods = false,
    this.showHiddenMods = false,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoCheckAppUpdates': autoCheckAppUpdates,
      'showDevMods': showDevMods,
      'showHiddenMods': showHiddenMods,
      'favoriteMods': favoriteMods.toList(),
      'hiddenMods': hiddenMods.toList(),
    };
  }
}
