import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/core/platform/open_external_url.dart';
import 'package:openra_launcher/features/discover/widgets/mod_database_info_header.widget.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database_info.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/widgets/button_row.widget.dart';
import 'package:openra_launcher/widgets/card_layout.widget.dart';

class DiscoverCard extends StatelessWidget {
  const DiscoverCard({super.key, required this.info});

  final ModDatabaseInfo info;

  @override
  Widget build(BuildContext context) {
    final openExternalUrl = getIt<OpenExternalUrl>();
    final l10n = AppLocalizations.of(context)!;

    final homepage = info.homepage;
    final repoUrl = info.repoUrl;
    final description = info.description;

    final hasHomepage = homepage != null;
    final hasRepo = repoUrl != null;

    final actions = <Widget>[];
    if (hasHomepage) {
      actions.add(OutlinedButton.icon(
        icon: const Icon(Icons.open_in_new),
        onPressed: () async {
          await openExternalUrl(homepage).run();
        },
        label: Text(l10n.visitHomepage),
      ));
    }
    if (hasRepo) {
      actions.add(TextButton.icon(
        icon: const Icon(Icons.code),
        onPressed: () async {
          await openExternalUrl(repoUrl).run();
        },
        label: Text(l10n.viewRepository),
      ));
    }

    final hasDescription = description != null && description.isNotEmpty;

    return CardLayout(
      header: ModDatabaseInfoHeader(info: info),
      description: hasDescription
          ? Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            )
          : null,
      bottom: actions.isEmpty ? null : ButtonRow(children: actions),
    );
  }
}
