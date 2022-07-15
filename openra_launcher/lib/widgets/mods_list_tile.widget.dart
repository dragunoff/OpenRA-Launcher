import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openra_launcher/models/mod.dart';
import 'package:openra_launcher/utils/mod_utils.dart';
import 'package:openra_launcher/widgets/fav_button.widget.dart';
import 'package:openra_launcher/widgets/loading_indicator.widget.dart';
import 'package:openra_launcher/widgets/mod_icon.widget.dart';
import 'package:openra_launcher/widgets/mod_release_info_chips.widget.dart';

class ModsListTile extends StatefulWidget {
  const ModsListTile({
    Key? key,
    required this.mod,
    this.isFavorite = false,
  }) : super(key: key);

  final Mod mod;
  final bool isFavorite;

  @override
  State<ModsListTile> createState() => _ModsListTileState();
}

class _ModsListTileState extends State<ModsListTile> {
  bool _isLaunching = false;
  bool _isHovered = false;

  void _setIsLaunching(bool isStarting) {
    setState(() {
      _isLaunching = isStarting;
    });
  }

  @override
  Widget build(BuildContext context) {
    final leading = ModIcon(mod: widget.mod);

    final favButtonWidget = FavButton(
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
          ModUtils.launchMod(widget.mod).whenComplete(() =>
              // NOTE: Add artificial delay to give the user feedback that something is going on
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
