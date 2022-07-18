import 'package:flutter/material.dart';
import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/widgets/mods_list_tile.widget.dart';

class ModsList extends StatelessWidget {
  const ModsList({Key? key, required this.mods, this.isFavoritesList = false})
      : super(key: key);

  final Set<Mod> mods;
  final bool isFavoritesList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: mods.length,
        itemBuilder: (BuildContext context, int index) {
          final Mod mod = mods.elementAt(index);
          return ModsListTile(mod: mod, isFavorite: isFavoritesList);
        });
  }
}
