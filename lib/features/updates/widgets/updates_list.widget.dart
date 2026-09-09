import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/features/updates/widgets/updates_card.widget.dart';
import 'package:openra_launcher/widgets/card_list_layout.widget.dart';

class UpdatesList extends StatelessWidget {
  const UpdatesList({super.key, required this.updates});

  final Set<Release> updates;

  @override
  Widget build(BuildContext context) {
    return CardListLayout(
      itemCount: updates.length,
      itemBuilder: (context, index) =>
          UpdatesCard(release: updates.elementAt(index)),
    );
  }
}
