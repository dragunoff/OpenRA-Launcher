import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/domain/entities/mod.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/selectors.dart';
import 'package:openra_launcher/widgets/loading_state.widget.dart';
import 'package:openra_launcher/widgets/mods_list.widget.dart';
import 'package:openra_launcher/widgets/mods_list_empty_state.widget.dart';
import 'package:openra_launcher/widgets/list_divider.widget.dart';
import 'package:redux/redux.dart';

class ModsHome extends StatelessWidget {
  const ModsHome({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          final officialMods = vm.officialMods;
          final communityMods = vm.communityMods;
          final favoriteMods = vm.favoriteMods;

          if (vm.modsListStatus == ListStatus.loading) {
            return const LoadingState(text: 'Scannig for installed mods...');
          }

          if (vm.modsListStatus == ListStatus.empty ||
              vm.modsListStatus == ListStatus.error) {
            return ModsListEmptyState(listStatus: vm.modsListStatus);
          }

          final List<Widget> children = [];

          if (favoriteMods.isNotEmpty) {
            children.add(const ListDivider('Favorite mods'));
            children.add(ModsList(mods: favoriteMods, isFavoritesList: true));
          }

          if (officialMods.isNotEmpty) {
            children.add(const ListDivider('Official mods'));
            children.add(ModsList(mods: officialMods));
          }

          if (communityMods.isNotEmpty) {
            children.add(const ListDivider('Community mods'));
            children.add(ModsList(mods: communityMods));
          }

          return SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children));
        });
  }
}

class _ViewModel {
  final Set<Mod> officialMods;
  final Set<Mod> communityMods;
  final Set<Mod> favoriteMods;
  final ListStatus modsListStatus;

  _ViewModel({
    required this.officialMods,
    required this.communityMods,
    required this.favoriteMods,
    required this.modsListStatus,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      officialMods: selectOfficialMods(store.state),
      communityMods: selectCommunityMods(store.state),
      favoriteMods: selectFavoriteMods(store.state),
      modsListStatus: store.state.modsListStatus,
    );
  }
}
