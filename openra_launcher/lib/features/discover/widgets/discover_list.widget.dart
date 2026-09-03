import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/features/discover/widgets/discover_card.widget.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database_info.dart';
import 'package:openra_launcher/widgets/card_list_layout.widget.dart';

class DiscoverList extends StatelessWidget {
  const DiscoverList({super.key, required this.mods});

  final Set<ModDatabaseInfo> mods;

  @override
  Widget build(BuildContext context) {
    return CardListLayout(
      itemCount: mods.length,
      itemBuilder: (context, index) =>
          DiscoverCard(info: mods.elementAt(index)),
    );
  }
}
