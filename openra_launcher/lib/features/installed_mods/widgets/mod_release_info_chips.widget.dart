import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/utils/mod_utils.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
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
      return Row(children: [
        Chip(
          label: Text(AppLocalizations.of(context)!.updatesNotSupported),
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
        final l10n = AppLocalizations.of(context)!;
        final List<Chip> chips = [];

        if (vm.hasRelease) {
          chips.add(Chip(
            label: Text(l10n.releaseAvailable),
            labelStyle: style,
          ));
        }

        if (vm.hasPlaytest) {
          chips.add(Chip(
            label: Text(l10n.playtestAvailable),
            labelStyle: style,
          ));
        }

        switch (vm.currentReleaseType) {
          case ModReleaseType.release:
            chips.add(Chip(
              label: Text(l10n.currentRelease),
              labelStyle: style,
            ));
            break;
          case ModReleaseType.playtest:
            chips.add(Chip(
              label: Text(l10n.currentPlaytest),
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
