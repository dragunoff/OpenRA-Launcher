import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/widgets/installed_mods_card.widget.dart';

class InstalledModsList extends StatelessWidget {
  const InstalledModsList({
    Key? key,
    required this.mods,
    this.isFavoritesList = false,
    this.hiddenMods = const {},
  }) : super(key: key);

  final Set<Mod> mods;
  final bool isFavoritesList;
  final Set<String> hiddenMods;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: mods.length,
        itemBuilder: (BuildContext context, int index) {
          final Mod mod = mods.elementAt(index);
          return InstalledModsCard(
            mod: mod,
            isFavorite: isFavoritesList,
            isHidden: hiddenMods.contains(mod.key),
          );
        });
  }
}
