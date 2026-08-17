import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';

class HideModAction {
  final Mod mod;

  HideModAction(this.mod);
}

class UnhideModAction {
  final Mod mod;

  UnhideModAction(this.mod);
}
