import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/show_hidden_mods/actions.dart';

class _ViewModel {
  const _ViewModel({
    required this.showHiddenMods,
    required this.toggleHiddenMods,
  });

  final bool showHiddenMods;
  final VoidCallback toggleHiddenMods;
}

class ToggleHiddenModsButton extends StatelessWidget {
  const ToggleHiddenModsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return _ViewModel(
          showHiddenMods: store.state.showHiddenMods,
          toggleHiddenMods: () => store.dispatch(
            store.state.showHiddenMods
                ? ShowHiddenModsOff()
                : ShowHiddenModsOn(),
          ),
        );
      },
      builder: (context, vm) {
        final l10n = AppLocalizations.of(context)!;

        return IconButton(
          icon: Icon(
            vm.showHiddenMods ? Icons.visibility : Icons.visibility_off,
          ),
          tooltip: l10n.toggleHiddenMods,
          onPressed: vm.toggleHiddenMods,
        );
      },
    );
  }
}
