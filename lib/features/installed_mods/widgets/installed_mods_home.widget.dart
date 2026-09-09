import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:openra_launcher/store/installed_mods/selectors.dart';
import 'package:openra_launcher/widgets/loading_state.widget.dart';
import 'package:openra_launcher/widgets/page_layout.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/installed_mods_list.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/installed_mods_list_empty_state.widget.dart';
import 'package:openra_launcher/widgets/toggle_hidden_mods_button.widget.dart';
import 'package:redux/redux.dart';

class InstalledModsHome extends StatelessWidget {
  const InstalledModsHome({super.key});

  @override
  Widget build(context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        final l10n = AppLocalizations.of(context)!;
        final installedMods = vm.installedMods;
        final favoriteMods = vm.favoriteMods;
        final devMods = vm.devMods;

        if (vm.modsListStatus == DataStatus.loading) {
          return LoadingState(text: l10n.scanningForInstalledMods);
        }

        if (vm.modsListStatus == DataStatus.empty ||
            vm.modsListStatus == DataStatus.error) {
          return InstalledModsListEmptyState(listStatus: vm.modsListStatus);
        }

        final List<Widget> children = [];

        if (favoriteMods.isNotEmpty) {
          children.add(
            InstalledModsList(
              mods: favoriteMods,
              isFavoritesList: true,
              hiddenMods: vm.hiddenMods,
            ),
          );
        }

        if (installedMods.isNotEmpty) {
          children.add(
            InstalledModsList(mods: installedMods, hiddenMods: vm.hiddenMods),
          );
        }

        if (devMods.isNotEmpty && vm.showDevMods) {
          children.add(
            InstalledModsList(mods: devMods, hiddenMods: vm.hiddenMods),
          );
        }

        return PageLayout(
          header: PageLayoutHeader(
            title: l10n.mods,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ToggleHiddenModsButton(),
                const SizedBox(width: AppConstants.spacing2x),
                TextButton.icon(
                  onPressed: vm.reloadMods,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.refreshMods),
                ),
              ],
            ),
          ),
          children: children,
        );
      },
    );
  }
}

class _ViewModel {
  final Set<Mod> installedMods;
  final Set<Mod> favoriteMods;
  final Set<Mod> devMods;
  final Set<String> hiddenMods;
  final bool showDevMods;
  final DataStatus modsListStatus;
  final VoidCallback reloadMods;

  _ViewModel({
    required this.installedMods,
    required this.favoriteMods,
    required this.devMods,
    required this.hiddenMods,
    required this.showDevMods,
    required this.modsListStatus,
    required this.reloadMods,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    final showHiddenMods = store.state.showHiddenMods;

    Set<Mod> filterHidden(Set<Mod> mods) {
      if (showHiddenMods) return mods;
      return mods
          .where((mod) => !store.state.hiddenMods.contains(mod.key))
          .toSet();
    }

    return _ViewModel(
      installedMods: filterHidden(selectInstalledMods(store.state)),
      favoriteMods: filterHidden(selectFavoriteMods(store.state)),
      devMods: filterHidden(selectDevMods(store.state)),
      hiddenMods: store.state.hiddenMods,
      showDevMods: store.state.showDevMods,
      modsListStatus: store.state.modsListStatus,
      reloadMods: () => store.dispatch(ReloadModsAction()),
    );
  }
}
