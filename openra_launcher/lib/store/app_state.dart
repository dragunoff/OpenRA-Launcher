import 'package:openra_launcher/models/app_release.dart';
import 'package:openra_launcher/models/mod.dart';
import 'package:openra_launcher/models/release.dart';

enum ListStatus {
  initial,
  empty,
  loading,
  loaded,
  error,
}

class AppState {
  final Set<Mod> mods;
  final Set<Release> releases;
  final Set<String> favoriteMods;
  final ListStatus modsListStatus;
  final ListStatus updatesListStatus;
  final bool autoCheckAppUpdates;
  final AppRelease? appRelease;

  AppState({
    this.mods = const {},
    this.releases = const {},
    this.favoriteMods = const {},
    this.modsListStatus = ListStatus.initial,
    this.updatesListStatus = ListStatus.initial,
    this.autoCheckAppUpdates = true,
    this.appRelease,
  });

  factory AppState.initial() => AppState();

  static AppState? fromJson(dynamic json) {
    if (json == null) return null;

    return AppState(
      favoriteMods: Set.from(json['favoriteMods'] ?? {}),
      autoCheckAppUpdates: json['autoCheckAppUpdates'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoCheckAppUpdates': autoCheckAppUpdates,
      'favoriteMods': favoriteMods.toList(),
    };
  }
}
