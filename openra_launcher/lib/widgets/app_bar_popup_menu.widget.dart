import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/core/platform/get_package_info.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:openra_launcher/store/show_dev_mods/actions.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:openra_launcher/widgets/about_dialog_contents.widget.dart';

enum Menu { refreshMods, checkForUpdates, showDevMods, showAboutDialog }

class AppBarPopupMenu extends StatelessWidget {
  const AppBarPopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(onSelected: (value) async {
      switch (value) {
        case Menu.showAboutDialog:
          {
            final packageInfo = await getIt<GetPackageInfo>()(NoParams()).run();

            if (context.mounted) {
              return showAboutDialog(
                context: context,
                applicationName: AppConstants.appName,
                applicationVersion: packageInfo.version,
                applicationLegalese: 'glhf by dragunoff',
                children: [
                  const AboutDialogContents(),
                ],
              );
            }
            break;
          }
        default:
          break;
      }
    }, itemBuilder: (BuildContext context) {
      final store = StoreProvider.of<AppState>(context);

      return <PopupMenuEntry<Menu>>[
        PopupMenuItem<Menu>(
          value: Menu.refreshMods,
          child: const Text('Refresh mods'),
          onTap: () {
            store.dispatch(ReloadModsAction());
          },
        ),
        PopupMenuItem<Menu>(
          value: Menu.checkForUpdates,
          child: const Text('Check for updates'),
          onTap: () {
            store.dispatch(LoadUpdatesAction());
          },
        ),
        CheckedPopupMenuItem<Menu>(
          value: Menu.showDevMods,
          checked: store.state.showDevMods,
          child: const Text('Show dev mods'),
          onTap: () {
            store.dispatch(
                store.state.showDevMods ? ShowDevModsOff() : ShowDevModsOn());
          },
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<Menu>(
          value: Menu.showAboutDialog,
          child: Text('About this app'),
        ),
      ];
    });
  }
}
