import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/widgets/card_header.widget.dart';
import 'package:openra_launcher/widgets/mod_icon.widget.dart';

class ModInfoHeader extends StatelessWidget {
  const ModInfoHeader({
    super.key,
    required this.mod,
    required this.version,
  });

  final Mod mod;
  final String version;

  @override
  Widget build(BuildContext context) {
    return CardHeader(
      leading: ModIcon(mod: mod),
      title: mod.title,
      subtitle: version,
    );
  }
}
