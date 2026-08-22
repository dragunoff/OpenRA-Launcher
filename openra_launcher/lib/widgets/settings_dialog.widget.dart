import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/auto_check_app_updates/actions.dart';
import 'package:openra_launcher/store/show_dev_mods/actions.dart';
import 'package:openra_launcher/store/show_hidden_mods/actions.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  final bool showDevMods;
  final bool showHiddenMods;
  final bool autoCheckAppUpdates;
  final VoidCallback toggleDevMods;
  final VoidCallback toggleHiddenMods;
  final VoidCallback autoCheckForAppUpdatesOn;
  final VoidCallback autoCheckForAppUpdatesOff;

  _ViewModel({
    required this.showDevMods,
    required this.showHiddenMods,
    required this.autoCheckAppUpdates,
    required this.toggleDevMods,
    required this.toggleHiddenMods,
    required this.autoCheckForAppUpdatesOn,
    required this.autoCheckForAppUpdatesOff,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      showDevMods: store.state.showDevMods,
      showHiddenMods: store.state.showHiddenMods,
      autoCheckAppUpdates: store.state.autoCheckAppUpdates,
      toggleDevMods: () => store.dispatch(
          store.state.showDevMods ? ShowDevModsOff() : ShowDevModsOn()),
      toggleHiddenMods: () => store.dispatch(store.state.showHiddenMods
          ? ShowHiddenModsOff()
          : ShowHiddenModsOn()),
      autoCheckForAppUpdatesOn: () =>
          store.dispatch(AutoCheckForAppUpdatesOn()),
      autoCheckForAppUpdatesOff: () =>
          store.dispatch(AutoCheckForAppUpdatesOff()),
    );
  }
}

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        final themeMode = AdaptiveTheme.of(context).mode;

        return AlertDialog(
          title: Text(l10n.settings),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.colorTheme),
              const SizedBox(height: 8),
              SegmentedButton<AdaptiveThemeMode>(
                segments: [
                  ButtonSegment(
                    value: AdaptiveThemeMode.light,
                    label: Text(l10n.light),
                    icon: const Icon(Icons.light_mode),
                  ),
                  ButtonSegment(
                    value: AdaptiveThemeMode.dark,
                    label: Text(l10n.dark),
                    icon: const Icon(Icons.dark_mode),
                  ),
                  ButtonSegment(
                    value: AdaptiveThemeMode.system,
                    label: Text(l10n.system),
                    icon: const Icon(Icons.brightness_auto),
                  ),
                ],
                selected: {themeMode},
                onSelectionChanged: (selected) {
                  AdaptiveTheme.of(context).setThemeMode(selected.first);
                },
              ),
              CheckboxListTile(
                title: Text(l10n.showHiddenMods),
                controlAffinity: ListTileControlAffinity.leading,
                value: vm.showHiddenMods,
                onChanged: (_) => vm.toggleHiddenMods(),
              ),
              CheckboxListTile(
                title: Text(l10n.showDevMods),
                controlAffinity: ListTileControlAffinity.leading,
                value: vm.showDevMods,
                onChanged: (_) => vm.toggleDevMods(),
              ),
              CheckboxListTile(
                title: Text(l10n.checkForAppUpdatesOnStartup),
                controlAffinity: ListTileControlAffinity.leading,
                value: vm.autoCheckAppUpdates,
                onChanged: (value) {
                  if (value == true) {
                    vm.autoCheckForAppUpdatesOn();
                  } else {
                    vm.autoCheckForAppUpdatesOff();
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }
}
