import 'package:flutter/material.dart';
import 'package:openra_launcher/constants/constants.dart';
import 'package:openra_launcher/models/mod.dart';
import 'package:openra_launcher/utils/mod_utils.dart';

class ModReleaseInfoChips extends StatelessWidget {
  const ModReleaseInfoChips({Key? key, required this.mod}) : super(key: key);
  final Mod mod;

  @override
  Widget build(BuildContext context) {
    final bool isSupported = ModUtils.isSupportedForUpdates(mod.id);

    const style = TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w200,
    );

    if (!isSupported) {
      return Row(children: const [
        Chip(
          label: Text('UPDATES NOT SUPPORTED'),
          labelStyle: style,
        )
      ]);
    }

    final List<Chip> chips = [];

    if (mod.hasRelease) {
      chips.add(const Chip(
        label: Text('RELEASE AVAILABLE'),
        labelStyle: style,
      ));
    }

    if (mod.hasPlaytest) {
      chips.add(const Chip(
        label: Text('PLAYTEST AVAILABLE'),
        labelStyle: style,
      ));
    }

    if (mod.isRelease) {
      chips.add(const Chip(
        label: Text('CURRENT RELEASE'),
        labelStyle: style,
      ));
    } else if (mod.isPlaytest) {
      chips.add(const Chip(
        label: Text('CURRENT PLAYTEST'),
        labelStyle: style,
      ));
    }

    final List<Container> wrappedChips = chips
        .map((chip) => Container(
              margin: const EdgeInsets.only(left: Constants.spacing),
              child: chip,
            ))
        .toList();

    return Row(
      children: wrappedChips,
    );
  }
}
