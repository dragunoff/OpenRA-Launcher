import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/core/platform/get_package_info.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:openra_launcher/store/show_dev_mods/actions.dart';
import 'package:openra_launcher/store/show_hidden_mods/actions.dart';
import 'package:openra_launcher/store/updates/actions.dart';

class _ViewModel {
  const _ViewModel({
    required this.showDevMods,
    required this.showHiddenMods,
    required this.reloadMods,
    required this.loadUpdates,
    required this.toggleDevMods,
    required this.toggleHiddenMods,
  });

  final bool showDevMods;
  final bool showHiddenMods;
  final VoidCallback reloadMods;
  final VoidCallback loadUpdates;
  final VoidCallback toggleDevMods;
  final VoidCallback toggleHiddenMods;
}

class AppBarPopupMenu extends StatelessWidget {
  const AppBarPopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(converter: (store) {
      return _ViewModel(
        showDevMods: store.state.showDevMods,
        showHiddenMods: store.state.showHiddenMods,
        reloadMods: () => store.dispatch(ReloadModsAction()),
        loadUpdates: () => store.dispatch(LoadUpdatesAction()),
        toggleDevMods: () => store.dispatch(
            store.state.showDevMods ? ShowDevModsOff() : ShowDevModsOn()),
        toggleHiddenMods: () => store.dispatch(store.state.showHiddenMods
            ? ShowHiddenModsOff()
            : ShowHiddenModsOn()),
      );
    }, builder: (context, vm) {
      final l10n = AppLocalizations.of(context)!;

      return Directionality(
          textDirection: TextDirection.rtl,
          child: MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
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
                  )),
              Directionality(
                  textDirection: TextDirection.ltr,
                  child: MenuItemButton(
                    onPressed: vm.loadUpdates,
                    child: Text(l10n.checkForUpdates),
                  )),
              const Divider(),
              Directionality(
                  textDirection: TextDirection.ltr,
                  child: MenuItemButton(
                    leadingIcon: vm.showDevMods
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    onPressed: vm.toggleDevMods,
                    closeOnActivate: false,
                    child: Text(l10n.showDevMods),
                  )),
              Directionality(
                  textDirection: TextDirection.ltr,
                  child: MenuItemButton(
                    leadingIcon: vm.showHiddenMods
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    onPressed: vm.toggleHiddenMods,
                    closeOnActivate: false,
                    child: Text(l10n.showHiddenMods),
                  )),
              const Divider(),
              Directionality(
                  textDirection: TextDirection.ltr,
                  child: MenuItemButton(
                    child: Text(l10n.aboutThisApp),
                    onPressed: () async {
                      final packageInfo =
                          await getIt<GetPackageInfo>()(NoParams()).run();

                      if (context.mounted) {
                        showAboutDialog(
                          context: context,
                          applicationName: AppConstants.appName,
                          applicationVersion: packageInfo.version,
                          applicationLegalese: l10n.appLegalese,
                        );
                      }
                    },
                  )),
            ],
          ));
    });
  }
}
