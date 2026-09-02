import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database_info.dart';
import 'package:openra_launcher/widgets/card_header.widget.dart';
import 'package:openra_launcher/widgets/image_placeholder.widget.dart';

class ModDatabaseInfoHeader extends StatelessWidget {
  const ModDatabaseInfoHeader({super.key, required this.info});

  final ModDatabaseInfo info;

  String? get _version {
    final stable = info.stable;
    if (stable != null) return stable.version;
    return info.playtest?.version;
  }

  @override
  Widget build(BuildContext context) {
    return CardHeader(
      leading: info.icon != null
          ? Image.memory(
              info.icon!,
              width: AppConstants.iconSize,
              height: AppConstants.iconSize,
            )
          : const ImagePlaceholder(),
      title: info.title,
      subtitle: _version,
    );
  }
}
