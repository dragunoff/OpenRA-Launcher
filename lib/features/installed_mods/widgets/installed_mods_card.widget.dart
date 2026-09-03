import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/utils/mod_utils.dart';
import 'package:openra_launcher/features/installed_mods/widgets/favorite_mod_button.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/mod_actions_menu_button.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/mod_launch_button.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/mod_release_info_chips.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/unhide_mod_button.widget.dart';
import 'package:openra_launcher/widgets/card_layout.widget.dart';
import 'package:openra_launcher/widgets/mod_info_header.widget.dart';

class InstalledModsCard extends StatelessWidget {
  const InstalledModsCard({
    super.key,
    required this.mod,
    this.isFavorite = false,
    this.isHidden = false,
  });

  final Mod mod;
  final bool isFavorite;
  final bool isHidden;

  @override
  Widget build(BuildContext context) {
    return CardLayout(
      header: ModInfoHeader(
        mod: mod,
        version: ModUtils.isDevMod(mod) ? '' : mod.version,
      ),
      topRight: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isHidden) UnhideModButton(mod: mod),
          FavoriteModButton(mod: mod, isFavorite: isFavorite),
          ModActionsMenuButton(mod: mod),
        ],
      ),
      bottom: Row(
        children: [
          ModLaunchButton(mod: mod),
          const Spacer(),
          ModReleaseInfoChips(mod: mod),
        ],
      ),
    );
  }
}
