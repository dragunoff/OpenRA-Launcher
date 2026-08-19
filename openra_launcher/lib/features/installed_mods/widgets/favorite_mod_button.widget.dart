import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/favorite_mods/actions.dart';
import 'package:openra_launcher/store/app_state.dart';

class FavoriteModButton extends StatelessWidget {
  const FavoriteModButton(
      {Key? key, required this.mod, required this.isFavorite})
      : super(key: key);

  final Mod mod;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(converter: ((store) {
      return isFavorite
          ? () => store.dispatch(RemoveModFromFavoritesAction(mod))
          : () => store.dispatch(AddModToFavoritesAction(mod));
    }), builder: (context, toggleFavoriteCallback) {
      final l10n = AppLocalizations.of(context)!;

      return Tooltip(
          message: isFavorite ? l10n.removeFromFavorites : l10n.addToFavorites,
          waitDuration: AppConstants.tooltipWaitDuration,
          child: IconButton(
            iconSize: 16,
            icon: isFavorite
                ? const Icon(Icons.star)
                : const Icon(Icons.star_border),
            onPressed: toggleFavoriteCallback,
          ));
    });
  }
}
