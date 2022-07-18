import 'package:openra_launcher/domain/entities/app_release.dart';
import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/domain/entities/release.dart';

class RemoveModFromFavoritesAction {
  final Mod mod;

  RemoveModFromFavoritesAction(this.mod);
}

class AddModToFavoritesAction {
  final Mod mod;

  AddModToFavoritesAction(this.mod);
}

class LoadModsAction {}

class ReloadModsAction {}

class ModsLoadedAction {
  final Set<Mod> mods;

  ModsLoadedAction(this.mods);
}

class ModsEmptyAction {}

class ModsErrorAction {}

class LoadUpdatesAction {}

class UpdatesLoadedAction {
  final Set<Release> releases;

  UpdatesLoadedAction(this.releases);
}

class UpdatesEmptyAction {}

class UpdatesErrorAction {}

class AutoCheckForAppUpdatesOn {}

class AutoCheckForAppUpdatesOff {}

class LoadAppUpdateAction {}

class AppUpdateLoadedAction {
  final AppRelease release;

  AppUpdateLoadedAction(this.release);
}

class AppUpdateEmptyAction {}

class AppUpdateErrorAction {}
