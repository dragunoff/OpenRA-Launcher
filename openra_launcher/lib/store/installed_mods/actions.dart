import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';

class LoadModsAction {}

class ReloadModsAction {}

class ModsLoadedAction {
  final Set<Mod> mods;

  ModsLoadedAction(this.mods);
}

class ModsEmptyAction {}

class ModsErrorAction {}
