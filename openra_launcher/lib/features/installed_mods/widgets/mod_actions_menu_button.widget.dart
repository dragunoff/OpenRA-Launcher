import 'package:material_ui/material_ui.dart';
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

class ModActionsMenuButton extends StatefulWidget {
  const ModActionsMenuButton({
    Key? key,
    required this.mod,
    this.onMenuToggle,
  }) : super(key: key);

  final Mod mod;
  final ValueChanged<bool>? onMenuToggle;

  @override
  State<ModActionsMenuButton> createState() => _ModActionsMenuButtonState();
}

class _ModActionsMenuButtonState extends State<ModActionsMenuButton> {
  final MenuController _menuController = MenuController();
  bool _lastIsOpen = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store, widget.mod),
        builder: (context, vm) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: MenuAnchor(
                controller: _menuController,
                builder: (BuildContext context, MenuController controller,
                    Widget? child) {
                  final isOpen = controller.isOpen;
                  if (isOpen != _lastIsOpen) {
                    _lastIsOpen = isOpen;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      widget.onMenuToggle?.call(isOpen);
                    });
                  }
                  return IconButton(
                    iconSize: 16,
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                  );
                },
                menuChildren: [
                  if (vm.isHidden)
                    Directionality(
                        textDirection: TextDirection.ltr,
                        child: MenuItemButton(
                          onPressed: vm.toggleFavorite,
                          leadingIcon: Icon(
                              vm.isFavorite ? Icons.star_border : Icons.star),
                          child: Text(
                            vm.isFavorite
                                ? 'Remove from favorites'
                                : 'Add to favorites',
                          ),
                        ))
                  else
                    Directionality(
                        textDirection: TextDirection.ltr,
                        child: MenuItemButton(
                          leadingIcon: Icon(vm.isFavorite
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: vm.toggleHidden,
                          child: const Text('Hide mod'),
                        )),
                ],
              ));
        });
  }
}
