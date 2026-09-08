import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:openra_launcher/store/show_dev_mods/actions.dart';
import 'package:openra_launcher/store/updates/actions.dart';

class _ViewModel {
  const _ViewModel({
    required this.showDevMods,
    required this.reloadMods,
    required this.loadUpdates,
    required this.toggleDevMods,
  });

  final bool showDevMods;
  final VoidCallback reloadMods;
  final VoidCallback loadUpdates;
  final VoidCallback toggleDevMods;
}

class AppBarPopupMenu extends StatelessWidget {
  const AppBarPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return _ViewModel(
          showDevMods: store.state.showDevMods,
          reloadMods: () => store.dispatch(ReloadModsAction()),
          loadUpdates: () => store.dispatch(LoadModDatabaseAction()),
          toggleDevMods: () => store.dispatch(
            store.state.showDevMods ? ShowDevModsOff() : ShowDevModsOn(),
          ),
        );
      },
      builder: (context, vm) {
        final l10n = AppLocalizations.of(context)!;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: MenuAnchor(
            builder:
                (
                  BuildContext context,
                  MenuController controller,
                  Widget? child,
                ) {
                  return IconButton(
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
              Directionality(
                textDirection: TextDirection.ltr,
                child: MenuItemButton(
                  onPressed: vm.reloadMods,
                  child: Text(l10n.refreshMods),
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: MenuItemButton(
                  onPressed: vm.loadUpdates,
                  child: Text(l10n.checkForUpdates),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
