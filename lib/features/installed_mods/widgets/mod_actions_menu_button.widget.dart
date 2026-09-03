import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/widgets/open_mod_folder_menu_item_button.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/open_url_menu_item_button.widget.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/hidden_mods/actions.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/updates/selectors.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  final bool isHidden;
  final String? homepage;
  final VoidCallback toggleHidden;

  _ViewModel({
    required this.isHidden,
    required this.homepage,
    required this.toggleHidden,
  });

  static _ViewModel fromStore(Store<AppState> store, Mod mod) {
    final isHidden = store.state.hiddenMods.contains(mod.key);
    return _ViewModel(
      isHidden: isHidden,
      homepage: selectModInfo(store.state, mod.id)?.homepage,
      toggleHidden: () =>
          store.dispatch(isHidden ? UnhideModAction(mod) : HideModAction(mod)),
    );
  }
}

class ModActionsMenuButton extends StatefulWidget {
  const ModActionsMenuButton({super.key, required this.mod, this.onMenuToggle});

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
        final l10n = AppLocalizations.of(context)!;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: MenuAnchor(
            controller: _menuController,
            builder:
                (
                  BuildContext context,
                  MenuController controller,
                  Widget? child,
                ) {
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
              if (!vm.isHidden)
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: MenuItemButton(
                    leadingIcon: const Icon(Icons.visibility_off),
                    onPressed: vm.toggleHidden,
                    child: Text(l10n.hideMod),
                  ),
                ),
              if (vm.homepage != null)
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: OpenUrlMenuItemButton(
                    label: l10n.visitHomepage,
                    url: vm.homepage!,
                    title: widget.mod.title,
                  ),
                ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: OpenModFolderMenuItemButton(
                  mod: widget.mod,
                  folder: ModFolderType.maps,
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: OpenModFolderMenuItemButton(
                  mod: widget.mod,
                  folder: ModFolderType.replays,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
