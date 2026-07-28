import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/services/mod_launch_service.dart';
import 'package:openra_launcher/features/installed_mods/widgets/favorite_mod_button.widget.dart';
import 'package:openra_launcher/widgets/loading_indicator.widget.dart';
import 'package:openra_launcher/widgets/mod_icon.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/mod_release_info_chips.widget.dart';
import 'package:openra_launcher/injection.dart';

class InstalledModsListTile extends StatefulWidget {
  const InstalledModsListTile({
    Key? key,
    required this.mod,
    this.isFavorite = false,
  }) : super(key: key);

  final Mod mod;
  final bool isFavorite;

  @override
  State<InstalledModsListTile> createState() => _InstalledModsListTileState();
}

class _InstalledModsListTileState extends State<InstalledModsListTile> {
  bool _isLaunching = false;
  bool _isHovered = false;

  Future<void> _launchMod() async {
    try {
      await getIt<ModLaunchService>().launch(widget.mod);
    } on ModLaunchException catch (error, stackTrace) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch ${widget.mod.title}'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'installed_mods',
          context: ErrorDescription('launching mod ${widget.mod.title}'),
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
    final leading = ModIcon(mod: widget.mod);

    final favButtonWidget = FavoriteModButton(
      mod: widget.mod,
      isFavorite: widget.isFavorite,
    );

    final favButtonOrLaunchingIndicator = SizedBox(
        width: 40,
        height: 40,
        child: _isLaunching ? const LoadingIndicator() : favButtonWidget);

    final List<Widget> trailingChildren = [];
    final releaseInfoChips = ModReleaseInfoChips(
      mod: widget.mod,
    );

    trailingChildren.add(releaseInfoChips);
    trailingChildren.add(favButtonOrLaunchingIndicator);

    return InkWell(
        onTap: () {
          _setIsLaunching(true);
          _launchMod().whenComplete(() =>
              // NOTE: Add artificial delay to give the user
              // feedback that something is going on
              Timer(const Duration(seconds: 1), () => _setIsLaunching(false)));
        },
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
          mouseCursor: SystemMouseCursors.click,
          enabled: !_isLaunching,
          leading: leading,
          title: Text(widget.mod.title),
          subtitle: Text(widget.mod.version),
          trailing: _isHovered
              ? FittedBox(child: Row(children: trailingChildren))
              : null,
        ));
  }
}
