import 'package:flutter/material.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/widgets/favorite_mod_button.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/mod_actions_menu_button.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/mod_launch_button.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/mod_release_info_chips.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/unhide_mod_button.widget.dart';
import 'package:openra_launcher/widgets/mod_icon.widget.dart';

class InstalledModsCard extends StatelessWidget {
  const InstalledModsCard({
    Key? key,
    required this.mod,
    this.isFavorite = false,
    this.isHidden = false,
  }) : super(key: key);

  final Mod mod;
  final bool isFavorite;
  final bool isHidden;

  @override
  Widget build(BuildContext context) {
    final Widget pinnedButton = isHidden
        ? UnhideModButton(mod: mod)
        : FavoriteModButton(
            mod: mod,
            isFavorite: isFavorite,
          );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing2x),
        child: Row(
          children: [
            ModIcon(mod: mod),
            const SizedBox(width: AppConstants.spacing2x),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mod.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    mod.version,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.spacing2x),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ModReleaseInfoChips(mod: mod),
                const SizedBox(width: AppConstants.spacing),
                ModLaunchButton(mod: mod),
                const SizedBox(width: AppConstants.spacing),
                pinnedButton,
                ModActionsMenuButton(mod: mod),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
