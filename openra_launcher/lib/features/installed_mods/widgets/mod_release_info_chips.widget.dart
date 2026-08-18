import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/utils/mod_utils.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/updates/selectors.dart';

class ModReleaseInfoChips extends StatelessWidget {
  const ModReleaseInfoChips({Key? key, required this.mod}) : super(key: key);
  final Mod mod;

  @override
  Widget build(BuildContext context) {
    final bool isSupported = ModUtils.isSupportedForUpdates(mod.id);

    const style = TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w200,
    );

    if (ModUtils.isDevMod(mod)) {
      return const Row(children: []);
    }

    if (!isSupported) {
      return const Row(children: [
        Chip(
          label: Text('UPDATES NOT SUPPORTED'),
          labelStyle: style,
        )
      ]);
    }

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        hasRelease: selectHasReleaseUpdate(store.state, mod),
        hasPlaytest: selectHasPlaytestUpdate(store.state, mod),
        currentReleaseType: selectCurrentModReleaseType(store.state, mod),
      ),
      builder: (context, vm) {
        final List<Chip> chips = [];

        if (vm.hasRelease) {
          chips.add(const Chip(
            label: Text('RELEASE AVAILABLE'),
            labelStyle: style,
          ));
        }

        if (vm.hasPlaytest) {
          chips.add(const Chip(
            label: Text('PLAYTEST AVAILABLE'),
            labelStyle: style,
          ));
        }

        switch (vm.currentReleaseType) {
          case ModReleaseType.release:
            chips.add(const Chip(
              label: Text('CURRENT RELEASE'),
              labelStyle: style,
            ));
            break;
          case ModReleaseType.playtest:
            chips.add(const Chip(
              label: Text('CURRENT PLAYTEST'),
              labelStyle: style,
            ));
            break;
          case ModReleaseType.none:
            break;
        }

        return Row(
          spacing: AppConstants.spacing,
          children: chips,
        );
      },
    );
  }
}

class _ViewModel {
  final bool hasRelease;
  final bool hasPlaytest;
  final ModReleaseType currentReleaseType;

  _ViewModel({
    required this.hasRelease,
    required this.hasPlaytest,
    required this.currentReleaseType,
  });
}
