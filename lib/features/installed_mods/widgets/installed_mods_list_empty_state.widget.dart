import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:openra_launcher/widgets/empty_state.widget.dart';

class InstalledModsListEmptyState extends StatelessWidget {
  const InstalledModsListEmptyState({
    super.key,
    this.listStatus = DataStatus.empty,
  });

  final DataStatus listStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasError = listStatus == DataStatus.error;

    return EmptyState(
      text: hasError ? l10n.modsScanError : l10n.noInstalledModsFound,
      buttonText: hasError ? l10n.tryAgain : l10n.refresh,
      buttonIcon: Icons.refresh,
      buttonOnPressed: () {
        StoreProvider.of<AppState>(context).dispatch(ReloadModsAction());
      },
    );
  }
}
