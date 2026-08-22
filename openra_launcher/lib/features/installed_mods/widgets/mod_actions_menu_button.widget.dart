import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/services/mod_folders_service.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
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

  Future<void> _openMapsFolder() {
    return _openFolder(
      () => getIt<ModFoldersService>().openMapsFolder(widget.mod),
      (l10n) => l10n.couldNotOpenMapsFolder(widget.mod.title),
    );
  }

  Future<void> _openReplaysFolder() {
    return _openFolder(
      () => getIt<ModFoldersService>().openReplaysFolder(widget.mod),
      (l10n) => l10n.couldNotOpenReplaysFolder(widget.mod.title),
    );
  }

  Future<void> _openFolder(
    TaskEither<PlatformFailure, Unit> Function() open,
    String Function(AppLocalizations l10n) buildErrorMessage,
  ) async {
    _menuController.close();

    final result = await open().run();

    if (!mounted || result.isRight()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(buildErrorMessage(AppLocalizations.of(context)!)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store, widget.mod),
        builder: (context, vm) {
          final l10n = AppLocalizations.of(context)!;

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
                                ? l10n.removeFromFavorites
                                : l10n.addToFavorites,
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
                          child: Text(l10n.hideMod),
                        )),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: MenuItemButton(
                      leadingIcon: const Icon(Icons.folder_open),
                      onPressed: _openMapsFolder,
                      child: Text(l10n.openMapsFolder),
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: MenuItemButton(
                      leadingIcon: const Icon(Icons.folder_open),
                      onPressed: _openReplaysFolder,
                      child: Text(l10n.openReplaysFolder),
                    ),
                  ),
                ],
              ));
        });
  }
}
