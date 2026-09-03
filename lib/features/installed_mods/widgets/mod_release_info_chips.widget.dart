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
    if (ModUtils.isDevMod(mod)) {
      return Chip(
        label: Text(AppLocalizations.of(context)!.devModVersion),
        labelStyle: AppConstants.chipTextStyle,
      );
    }

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        modDatabaseStatus: store.state.modDatabaseStatus,
        isSupported: selectIsModSupported(store.state, mod.id),
        currentReleaseType: selectCurrentModReleaseType(store.state, mod),
      ),
      builder: (context, vm) {
        final l10n = AppLocalizations.of(context)!;
        final List<Chip> chips = [];

        if (vm.modDatabaseStatus == DataStatus.initial ||
            vm.modDatabaseStatus == DataStatus.loading ||
            vm.modDatabaseStatus == DataStatus.error) {
          return const SizedBox.shrink();
        }

        if (!vm.isSupported) {
          return Chip(
            label: Text(l10n.updatesNotSupported),
            labelStyle: AppConstants.chipTextStyle,
          );
        }

        switch (vm.currentReleaseType) {
          case ModReleaseType.release:
            chips.add(
              Chip(
                label: Text(l10n.currentRelease),
                labelStyle: AppConstants.chipTextStyle,
              ),
            );
            break;
          case ModReleaseType.playtest:
            chips.add(
              Chip(
                label: Text(l10n.currentPlaytest),
                labelStyle: AppConstants.chipTextStyle,
              ),
            );
            break;
          case ModReleaseType.none:
            break;
        }

        return Row(spacing: AppConstants.spacing, children: chips);
      },
    );
  }
}

class _ViewModel {
  final DataStatus modDatabaseStatus;
  final bool isSupported;
  final ModReleaseType currentReleaseType;

  _ViewModel({
    required this.modDatabaseStatus,
    required this.isSupported,
    required this.currentReleaseType,
  });
}
