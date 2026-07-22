import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/widgets/image_placeholder.widget.dart';

class ModIcon extends StatelessWidget {
  const ModIcon({Key? key, required this.mod}) : super(key: key);

  final Mod mod;

  @override
  Widget build(BuildContext context) {
    return mod.icon != null
        ? Image.memory(
            mod.icon as Uint8List,
            width: AppConstants.iconSize,
            height: AppConstants.iconSize,
          )
        : const ImagePlaceholder();
  }
}
