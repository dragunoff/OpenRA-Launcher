import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/store/favorite_mods/actions.dart';
import 'package:openra_launcher/store/hidden_mods/actions.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  final bool isHidden;
  final bool isFavorite;
  final VoidCallback toggleHidden;
  final VoidCallback toggleFavorite;

  _ViewModel({
    required this.isHidden,
    required this.isFavorite,
    required this.toggleHidden,
    required this.toggleFavorite,
  });

  static _ViewModel fromStore(Store<AppState> store, Mod mod) {
    final isHidden = store.state.hiddenMods.contains(mod.key);
    final isFavorite = store.state.favoriteMods.contains(mod.key);
    return _ViewModel(
      isHidden: isHidden,
      isFavorite: isFavorite,
      toggleHidden: () => store.dispatch(
        isHidden ? UnhideModAction(mod) : HideModAction(mod),
      ),
      toggleFavorite: () => store.dispatch(
        isFavorite
            ? RemoveModFromFavoritesAction(mod)
            : AddModToFavoritesAction(mod),
      ),
    );
  }
}

class ModActionsMenuButton extends StatelessWidget {
  const ModActionsMenuButton({Key? key, required this.mod}) : super(key: key);

  final Mod mod;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store, mod),
      builder: (context, vm) {
        return PopupMenuButton<String>(
          iconSize: 16,
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            if (vm.isHidden)
              PopupMenuItem<String>(
                onTap: vm.toggleFavorite,
                value: 'toggle_favorite',
                child: Text(
                  vm.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                ),
              )
            else
              PopupMenuItem<String>(
                onTap: vm.toggleHidden,
                value: 'toggle_hidden',
                child: const Text('Hide mod'),
              ),
          ],
        );
      },
    );
  }
}
