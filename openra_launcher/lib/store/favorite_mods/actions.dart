import 'package:openra_launcher/domain/entities/mod.dart';

class RemoveModFromFavoritesAction {
  final Mod mod;

  RemoveModFromFavoritesAction(this.mod);
}

class AddModToFavoritesAction {
  final Mod mod;

  AddModToFavoritesAction(this.mod);
}
