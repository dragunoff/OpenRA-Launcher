import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/updates/selectors.dart';
import 'package:openra_launcher/widgets/list_divider.widget.dart';
import 'package:openra_launcher/widgets/loading_state.widget.dart';
import 'package:openra_launcher/features/updates/widgets/updates_list.widget.dart';
import 'package:openra_launcher/features/updates/widgets/updates_list_empty_state.widget.dart';
import 'package:redux/redux.dart';

class UpdatesHome extends StatelessWidget {
  const UpdatesHome({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          final l10n = AppLocalizations.of(context)!;

          if (vm.modsListStatus == ListStatus.loading) {
            return LoadingState(text: l10n.scanningForInstalledMods);
          } else if (vm.updatesListStatus == ListStatus.loading) {
            return LoadingState(text: l10n.checkingForUpdates);
          }

          if (vm.updatesListStatus == ListStatus.empty ||
              vm.updatesListStatus == ListStatus.error) {
            return UpdatesListEmptyState(listStatus: vm.updatesListStatus);
          }

          final List<Widget> children = [];

          if (vm.releases.isNotEmpty) {
            children.add(ListDivider(l10n.releaseAvailableSection));
            children.add(UpdatesList(releases: vm.releases));
          }

          if (vm.playtests.isNotEmpty) {
            children.add(ListDivider(l10n.playtestAvailableSection));
            children.add(UpdatesList(releases: vm.playtests));
          }

          return SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children));
        });
  }
}

class _ViewModel {
  final Set<Release> releases;
  final Set<Release> playtests;
  final ListStatus modsListStatus;
  final ListStatus updatesListStatus;

  _ViewModel({
    required this.releases,
    required this.playtests,
    required this.modsListStatus,
    required this.updatesListStatus,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    final hiddenModIds = store.state.mods
        .where((mod) => store.state.hiddenMods.contains(mod.key))
        .map((mod) => mod.id)
        .toSet();

    Set<Release> filterHidden(Set<Release> releases) {
      if (store.state.showHiddenMods) return releases;
      return releases
          .where((release) => !hiddenModIds.contains(release.modId))
          .toSet();
    }

    return _ViewModel(
      releases: filterHidden(selectReleaseUpdates(store.state)),
      playtests: filterHidden(selectPlaytestUpdates(store.state)),
      modsListStatus: store.state.modsListStatus,
      updatesListStatus: store.state.updatesListStatus,
    );
  }
}
