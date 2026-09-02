import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/discover/widgets/discover_card.widget.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database_info.dart';

class DiscoverList extends StatelessWidget {
  const DiscoverList({super.key, required this.mods});

  final Set<ModDatabaseInfo> mods;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final info in mods) ...[
          DiscoverCard(info: info),
          const SizedBox(height: AppConstants.spacing),
        ],
      ],
    );
  }
}
