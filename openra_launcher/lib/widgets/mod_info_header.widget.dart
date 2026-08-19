import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/widgets/mod_icon.widget.dart';

class ModInfoHeader extends StatelessWidget {
  const ModInfoHeader({
    Key? key,
    required this.mod,
    required this.version,
  }) : super(key: key);

  final Mod mod;
  final String version;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                version,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
