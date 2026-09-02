import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/utils/mod_utils.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/updates/selectors.dart';

class ModReleaseInfoChips extends StatelessWidget {
  const ModReleaseInfoChips({super.key, required this.mod});
  final Mod mod;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w200,
    );

    if (ModUtils.isDevMod(mod)) {
      return Row(children: [
        Chip(
          label: Text(AppLocalizations.of(context)!.devModVersion),
          labelStyle: style,
        )
      ]);
    }

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        updatesListStatus: store.state.updatesListStatus,
        isSupported: selectIsModSupported(store.state, mod.id),
        currentReleaseType: selectCurrentModReleaseType(store.state, mod),
      ),
      builder: (context, vm) {
        final l10n = AppLocalizations.of(context)!;
        final List<Chip> chips = [];

        if (vm.updatesListStatus == ListStatus.initial ||
            vm.updatesListStatus == ListStatus.loading ||
            vm.updatesListStatus == ListStatus.error) {
          return const SizedBox.shrink();
        }

        if (!vm.isSupported) {
          return Row(children: [
            Chip(
              label: Text(l10n.updatesNotSupported),
              labelStyle: style,
            )
          ]);
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
  final ListStatus updatesListStatus;
  final bool isSupported;
  final ModReleaseType currentReleaseType;

  _ViewModel({
    required this.updatesListStatus,
    required this.isSupported,
    required this.currentReleaseType,
  });
}
