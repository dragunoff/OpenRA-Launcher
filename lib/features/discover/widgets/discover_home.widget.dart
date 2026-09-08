import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/features/discover/widgets/discover_list.widget.dart';
import 'package:openra_launcher/features/discover/widgets/discover_list_empty_state.widget.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database_info.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:openra_launcher/store/updates/selectors.dart';
import 'package:openra_launcher/widgets/loading_state.widget.dart';
import 'package:openra_launcher/widgets/page_layout.widget.dart';
import 'package:redux/redux.dart';

class DiscoverHome extends StatelessWidget {
  const DiscoverHome({super.key});

  @override
  Widget build(context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        final l10n = AppLocalizations.of(context)!;

        if (vm.modsListStatus == DataStatus.loading) {
          return LoadingState(text: l10n.scanningForInstalledMods);
        } else if (vm.modDatabaseStatus == DataStatus.loading) {
          return LoadingState(text: l10n.fetchingDatabase);
        }

        if (vm.modDatabaseStatus == DataStatus.empty ||
            vm.modDatabaseStatus == DataStatus.error) {
          return DiscoverListEmptyState(listStatus: vm.modDatabaseStatus);
        }

        return PageLayout(
          header: PageLayoutHeader(
            title: l10n.discover,
            trailing: TextButton.icon(
              onPressed: vm.loadDatabase,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.refreshDatabase),
            ),
          ),
          children: [DiscoverList(mods: vm.discoverableMods)],
        );
      },
    );
  }
}

class _ViewModel {
  final Set<ModDatabaseInfo> discoverableMods;
  final DataStatus modsListStatus;
  final DataStatus modDatabaseStatus;
  final VoidCallback loadDatabase;

  _ViewModel({
    required this.discoverableMods,
    required this.modsListStatus,
    required this.modDatabaseStatus,
    required this.loadDatabase,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      discoverableMods: selectDiscoverableMods(store.state),
      modsListStatus: store.state.modsListStatus,
      modDatabaseStatus: store.state.modDatabaseStatus,
      loadDatabase: () => store.dispatch(LoadModDatabaseAction()),
    );
  }
}
