import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/app_update/domain/entities/app_release.dart';
import 'package:openra_launcher/features/app_update/widgets/app_update_dialog.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/installed_mods_home.widget.dart';
import 'package:openra_launcher/features/updates/widgets/updates_home.widget.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/updates/selectors.dart';
import 'package:openra_launcher/widgets/app_bar_popup_menu.widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title, required this.onInit})
      : super(key: key);

  final String title;
  final void Function() onInit;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool shoudlOpenUpdateDialog = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = StoreProvider.of<AppState>(context).state;

    final AppRelease? appRelease = appState.appRelease;
    final bool checkFoUpdates = appState.autoCheckAppUpdates;
    final updatesCount = selectUpdatesCount(appState);

    Future.delayed(Duration.zero, () {
      if (shoudlOpenUpdateDialog && checkFoUpdates && appRelease != null) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AppUpdateDialog(appRelease: appRelease),
          );
          setState(() {
            shoudlOpenUpdateDialog = false;
          });
        }
      }
    });

    final destinations = <_HomeDestination>[
      _HomeDestination(
        id: 'mods',
        label: 'Mods',
        icon: Icons.list,
        selectedIcon: Icons.list,
        content: const InstalledModsHome(),
      ),
      _HomeDestination(
        id: 'updates',
        label: 'Updates',
        icon: Icons.update,
        selectedIcon: Icons.update,
        content: const UpdatesHome(),
      ),
    ];

    final selectedDestination = destinations[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.spacing),
              child: Row(spacing: AppConstants.spacing, children: [
                AppBarPopupMenu(),
              ]))
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            minExtendedWidth: 220,
            extended: true,
            useIndicator: true,
            destinations: destinations.map(
              (destination) {
                Widget iconWidget = Icon(destination.icon);
                Widget selectedIconWidget = Icon(destination.selectedIcon);

                if (destination.id == 'updates' && updatesCount > 0) {
                  final label = Text(
                    updatesCount.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 10,
                    ),
                  );

                  iconWidget = Badge(
                    label: label,
                    child: Icon(destination.icon),
                  );

                  selectedIconWidget = Badge(
                    label: label,
                    child: Icon(destination.selectedIcon),
                  );
                }

                return NavigationRailDestination(
                  icon: iconWidget,
                  selectedIcon: selectedIconWidget,
                  label: Text(destination.label),
                );
              },
            ).toList(),
          ),
          Expanded(
            child: Material(
              color: Theme.of(context).colorScheme.surfaceContainer,
              elevation: 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: selectedDestination.content,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeDestination {
  const _HomeDestination({
    required this.id,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.content,
  });

  final String id;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget content;
}
