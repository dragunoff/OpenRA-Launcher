import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/app_update/domain/entities/app_release.dart';
import 'package:openra_launcher/features/app_update/widgets/app_update_dialog.widget.dart';
import 'package:openra_launcher/features/discover/widgets/discover_home.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/installed_mods_home.widget.dart';
import 'package:openra_launcher/features/updates/widgets/updates_home.widget.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/updates/selectors.dart';
import 'package:openra_launcher/widgets/app_bar_popup_menu.widget.dart';
import 'package:openra_launcher/widgets/settings_dialog.widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title, required this.onInit});

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

    final l10n = AppLocalizations.of(context)!;

    final destinations = <_HomeDestination>[
      _HomeDestination(
        id: 'mods',
        label: l10n.mods,
        icon: Icons.list,
        selectedIcon: Icons.list,
        content: const InstalledModsHome(),
      ),
      _HomeDestination(
        id: 'updates',
        label: l10n.updates,
        icon: Icons.update,
        selectedIcon: Icons.update,
        content: const UpdatesHome(),
      ),
      _HomeDestination(
        id: 'discover',
        label: l10n.discover,
        icon: Icons.travel_explore,
        selectedIcon: Icons.travel_explore,
        content: const DiscoverHome(),
      ),
    ];

    final selectedDestination = destinations[_selectedIndex];

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.spacing),
          child: Row(
            spacing: AppConstants.spacing,
            children: [
              Text(widget.title),
              Spacer(),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const SettingsDialog(),
                ),
              ),
              AppBarPopupMenu(),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final extended =
              constraints.maxWidth > AppConstants.smallScreenBreakpoint;
          return Row(
            children: [
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                minExtendedWidth: 220,
                extended: extended,
                labelType: extended
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.all,
                useIndicator: true,
                destinations: destinations.map((destination) {
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
                }).toList(),
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
          );
        },
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
