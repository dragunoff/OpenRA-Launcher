import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/core/platform/open_external_url.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/selectors.dart';
import 'package:openra_launcher/features/updates/widgets/updates_card_menu_button.widget.dart';
import 'package:openra_launcher/widgets/card_layout.widget.dart';
import 'package:openra_launcher/widgets/mod_info_header.widget.dart';

class UpdatesCard extends StatelessWidget {
  const UpdatesCard({
    super.key,
    required this.release,
    this.isFavorite = false,
  });

  final Release release;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final openExternalUrl = getIt<OpenExternalUrl>();

    return StoreConnector<AppState, dynamic>(
      converter: (store) => selectModById(store.state, release.modId),
      builder: (context, mod) {
        return CardLayout(
          header: ModInfoHeader(mod: mod, version: release.version),
          topRight: UpdatesCardMenuButton(release: release),
          bottom: Row(
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.download),
                onPressed: () async {
                  await openExternalUrl(release.htmlUrl).run();
                },
                label: Text(AppLocalizations.of(context)!.download),
              ),
            ],
          ),
        );
      },
    );
  }
}
