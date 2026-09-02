import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/core/platform/open_external_url.dart';
import 'package:openra_launcher/features/discover/widgets/mod_database_info_header.widget.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database_info.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
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

    final hasLink = homepage != null || repoUrl != null;
    final label = homepage != null ? l10n.visitHomepage : l10n.viewRepository;

    final hasDescription = description != null && description.isNotEmpty;

    return CardLayout(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ModDatabaseInfoHeader(info: info),
          if (hasDescription) ...[
            const SizedBox(height: AppConstants.spacing),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (hasLink) ...[
            const SizedBox(height: AppConstants.spacing),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.open_in_new),
                onPressed: () async {
                  await openExternalUrl(homepage ?? repoUrl!).run();
                },
                label: Text(label),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
