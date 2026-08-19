import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/features/updates/widgets/updates_card.widget.dart';
import 'package:openra_launcher/widgets/card_grid.widget.dart';

class UpdatesList extends StatelessWidget {
  const UpdatesList({Key? key, required this.releases}) : super(key: key);

  final Set<Release> releases;

  @override
  Widget build(BuildContext context) {
    return CardGrid(
      itemCount: releases.length,
      itemBuilder: (context, index) {
        final Release release = releases.elementAt(index);
        return UpdatesCard(release: release);
      },
    );
  }
}
