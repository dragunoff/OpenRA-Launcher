import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:openra_launcher/store/updates/selectors.dart';
import 'package:openra_launcher/widgets/loading_state.widget.dart';
import 'package:openra_launcher/widgets/page_layout.widget.dart';
import 'package:openra_launcher/features/updates/widgets/updates_list.widget.dart';
import 'package:openra_launcher/features/updates/widgets/updates_list_empty_state.widget.dart';
import 'package:redux/redux.dart';

class UpdatesHome extends StatelessWidget {
  const UpdatesHome({super.key});

  @override
  Widget build(context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        final l10n = AppLocalizations.of(context)!;

        if (vm.modsListStatus == DataStatus.loading) {
          return LoadingState(text: l10n.scanningForInstalledMods);
        } else if (vm.modDatabaseStatus == DataStatus.loading) {
          return LoadingState(text: l10n.checkingForUpdates);
        }

        if (vm.modDatabaseStatus == DataStatus.empty ||
            vm.modDatabaseStatus == DataStatus.error) {
          return UpdatesListEmptyState(listStatus: vm.modDatabaseStatus);
        }

        final List<Widget> children = [];

        if (vm.releases.isNotEmpty) {
          children.add(UpdatesList(releases: vm.releases));
        }

        if (vm.playtests.isNotEmpty) {
          children.add(UpdatesList(releases: vm.playtests));
        }

        return PageLayout(
          header: PageLayoutHeader(
            title: l10n.updates,
            trailing: TextButton.icon(
              onPressed: vm.loadUpdates,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.checkForUpdates),
            ),
          ),
          children: children,
        );
      },
    );
  }
}

class _ViewModel {
  final Set<Release> releases;
  final Set<Release> playtests;
  final DataStatus modsListStatus;
  final DataStatus modDatabaseStatus;
  final VoidCallback loadUpdates;

  _ViewModel({
    required this.releases,
    required this.playtests,
    required this.modsListStatus,
    required this.modDatabaseStatus,
    required this.loadUpdates,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    final hiddenModIds = store.state.mods
        .where((mod) => store.state.hiddenMods.contains(mod.key))
        .map((mod) => mod.id)
        .toSet();

    Set<Release> filterHidden(Set<Release> releases) {
      return releases
          .where((release) => !hiddenModIds.contains(release.modId))
          .toSet();
    }

    return _ViewModel(
      releases: filterHidden(selectAvailableReleaseUpdates(store.state)),
      playtests: filterHidden(selectAvailablePlaytestUpdates(store.state)),
      modsListStatus: store.state.modsListStatus,
      modDatabaseStatus: store.state.modDatabaseStatus,
      loadUpdates: () => store.dispatch(LoadModDatabaseAction()),
    );
  }
}
