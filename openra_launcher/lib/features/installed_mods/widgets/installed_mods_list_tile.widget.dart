import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/services/mod_launch_service.dart';
import 'package:openra_launcher/features/installed_mods/widgets/favorite_mod_button.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/mod_actions_menu_button.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/unhide_mod_button.widget.dart';
import 'package:openra_launcher/widgets/mod_icon.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/mod_release_info_chips.widget.dart';
import 'package:openra_launcher/injection.dart';

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
  bool _isLaunching = false;
  bool _isHovered = false;

  Future<void> _launchMod() async {
    try {
      await getIt<ModLaunchService>().launch(widget.mod);
    } on ModLaunchException catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch ${widget.mod.title}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _setIsLaunching(bool isStarting) {
    setState(() {
      _isLaunching = isStarting;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> trailingChildren = [
      ModReleaseInfoChips(
        mod: widget.mod,
      ),
      FilledButton.icon(
          icon: const Icon(Icons.rocket),
          onPressed: () async {
            if (_isLaunching) {
              return;
            }

            _setIsLaunching(true);
            _launchMod().whenComplete(() =>
                // NOTE: Artificial delay to give feedback that something is going on
                Timer(
                  const Duration(milliseconds: 500),
                  () => _setIsLaunching(false),
                ));
          },
          label: const Text('Launch')),
      widget.isHidden
          ? UnhideModButton(mod: widget.mod)
          : FavoriteModButton(
              mod: widget.mod,
              isFavorite: widget.isFavorite,
            ),
      ModActionsMenuButton(mod: widget.mod),
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
          trailing: _isHovered
              ? FittedBox(
                  child: Row(
                  spacing: AppConstants.spacing,
                  children: trailingChildren,
                ))
              : null,
        ));
  }
}
