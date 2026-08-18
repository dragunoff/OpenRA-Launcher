import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/store/hidden_mods/actions.dart';
import 'package:openra_launcher/store/app_state.dart';

class UnhideModButton extends StatelessWidget {
  const UnhideModButton({Key? key, required this.mod}) : super(key: key);

  final Mod mod;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(
      converter: (store) {
        return () => store.dispatch(UnhideModAction(mod));
      },
      builder: (context, unhideCallback) {
        return Tooltip(
          message: 'Unhide mod',
          waitDuration: AppConstants.tooltipWaitDuration,
          child: IconButton(
            iconSize: 16,
            icon: const Icon(Icons.visibility_off),
            onPressed: unhideCallback,
          ),
        );
      },
    );
  }
}
