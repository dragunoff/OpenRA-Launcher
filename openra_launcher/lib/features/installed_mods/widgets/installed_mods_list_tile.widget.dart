import 'package:flutter/material.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/widgets/favorite_mod_button.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/mod_actions_menu_button.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/mod_launch_button.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/unhide_mod_button.widget.dart';
import 'package:openra_launcher/widgets/mod_icon.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/mod_release_info_chips.widget.dart';

class InstalledModsListTile extends StatefulWidget {
  const InstalledModsListTile({
    Key? key,
    required this.mod,
    this.isFavorite = false,
    this.isHidden = false,
  }) : super(key: key);

  final Mod mod;
  final bool isFavorite;
  final bool isHidden;

  @override
  State<InstalledModsListTile> createState() => _InstalledModsListTileState();
}

class _InstalledModsListTileState extends State<InstalledModsListTile> {
  bool _isHovered = false;
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final Widget pinnedButton = widget.isHidden
        ? UnhideModButton(mod: widget.mod)
        : FavoriteModButton(
            mod: widget.mod,
            isFavorite: widget.isFavorite,
          );

    final Widget actionsMenuButton = ModActionsMenuButton(
        mod: widget.mod,
        onMenuToggle: (open) {
          setState(() {
            _isMenuOpen = open;
          });
        });

    final List<Widget> trailingChildren = [
      ModReleaseInfoChips(
        mod: widget.mod,
      ),
      ModLaunchButton(mod: widget.mod),
      pinnedButton,
      actionsMenuButton,
    ];

    return InkWell(
        onTap: () {},
        onHover: (hovering) {
          setState(() {
            _isHovered = hovering;
          });
        },
        onFocusChange: (focused) {
          setState(() {
            _isHovered = focused;
          });
        },
        child: ListTile(
            leading: ModIcon(mod: widget.mod),
            title: Text(widget.mod.title),
            subtitle: Text(widget.mod.version),
            trailing: FittedBox(
                child: Row(
              spacing: AppConstants.spacing,
              children: (_isHovered || _isMenuOpen) ? trailingChildren : [],
            ))));
  }
}
