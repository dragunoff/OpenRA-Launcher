import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/selectors.dart';
import 'package:openra_launcher/widgets/list_divider.widget.dart';
import 'package:openra_launcher/widgets/loading_state.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/installed_mods_list.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/installed_mods_list_empty_state.widget.dart';
import 'package:redux/redux.dart';

class InstalledModsHome extends StatelessWidget {
  const InstalledModsHome({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          final installedMods = vm.installedMods;
          final favoriteMods = vm.favoriteMods;
          final devMods = vm.devMods;

          if (vm.modsListStatus == ListStatus.loading) {
            return const LoadingState(text: 'Scannig for installed mods...');
          }

          if (vm.modsListStatus == ListStatus.empty ||
              vm.modsListStatus == ListStatus.error) {
            return InstalledModsListEmptyState(listStatus: vm.modsListStatus);
          }

          final List<Widget> children = [];

          if (favoriteMods.isNotEmpty) {
            children.add(const ListDivider('Favorites'));
            children.add(
                InstalledModsList(mods: favoriteMods, isFavoritesList: true));
          }

          if (installedMods.isNotEmpty) {
            children.add(const ListDivider('Installed'));
            children.add(InstalledModsList(mods: installedMods));
          }

          if (devMods.isNotEmpty && vm.showDevMods) {
            children.add(const ListDivider('Development'));
            children.add(InstalledModsList(mods: devMods));
          }

          return SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children));
        });
  }
}

class _ViewModel {
  final Set<Mod> installedMods;
  final Set<Mod> favoriteMods;
  final Set<Mod> devMods;
  final bool showDevMods;
  final ListStatus modsListStatus;

  _ViewModel({
    required this.installedMods,
    required this.favoriteMods,
    required this.devMods,
    required this.showDevMods,
    required this.modsListStatus,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      installedMods: selectInstalledMods(store.state),
      favoriteMods: selectFavoriteMods(store.state),
      devMods: selectDevMods(store.state),
      showDevMods: store.state.showDevMods,
      modsListStatus: store.state.modsListStatus,
    );
  }
}
