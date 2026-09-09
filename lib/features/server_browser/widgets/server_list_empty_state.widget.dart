import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/server_list/actions.dart';
import 'package:openra_launcher/widgets/empty_state.widget.dart';

class ServerListEmptyState extends StatelessWidget {
  const ServerListEmptyState({super.key, this.listStatus = DataStatus.empty});

  final DataStatus listStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasError = listStatus == DataStatus.error;

    return EmptyState(
      text: hasError ? l10n.serversFetchError : l10n.noServersFound,
      buttonText: l10n.checkNow,
      buttonIcon: Icons.refresh,
      buttonOnPressed: () {
        StoreProvider.of<AppState>(context).dispatch(LoadServerListAction());
      },
    );
  }
}
