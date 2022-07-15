import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/constants.dart';
import 'package:openra_launcher/store/actions.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/utils/platform_utils.dart';
import 'package:openra_launcher/widgets/about_dialog_contents.widget.dart';

enum Menu { refreshMods, checkForUpdates, showAboutDialog }

class AppBarPopupMenu extends StatelessWidget {
  const AppBarPopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
        onSelected: (value) async {
          switch (value) {
            case Menu.showAboutDialog:
              {
                var packageInfo = await PlatformUtils.getPackageInfo();
                return showAboutDialog(
                  context: context,
                  applicationName: Constants.appName,
                  applicationVersion: packageInfo.version,
                  applicationLegalese: 'glhf by dragunoff',
                  children: [
                    const AboutDialogContents(),
                  ],
                );
              }
            default:
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              PopupMenuItem<Menu>(
                value: Menu.refreshMods,
                child: const Text('Refresh mods'),
                onTap: () {
                  StoreProvider.of<AppState>(context)
                      .dispatch(ReloadModsAction());
                },
              ),
              PopupMenuItem<Menu>(
                value: Menu.checkForUpdates,
                child: const Text('Check for updates'),
                onTap: () {
                  StoreProvider.of<AppState>(context)
                      .dispatch(LoadUpdatesAction());
                },
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<Menu>(
                value: Menu.showAboutDialog,
                child: Text('About this app'),
              ),
            ]);
  }
}
