import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/features/installed_mods/widgets/open_url_menu_item_button.widget.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/selectors.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  final String? homepage;
  final String modTitle;

  _ViewModel({
    required this.homepage,
    required this.modTitle,
  });

  static _ViewModel fromStore(Store<AppState> store, Release release) {
    return _ViewModel(
      homepage: store.state.modDatabase.mods[release.modId]?.homepage,
      modTitle: selectModById(store.state, release.modId).title,
    );
  }
}

class UpdatesCardMenuButton extends StatefulWidget {
  const UpdatesCardMenuButton({
    Key? key,
    required this.release,
    this.onMenuToggle,
  }) : super(key: key);

  final Release release;
  final ValueChanged<bool>? onMenuToggle;

  @override
  State<UpdatesCardMenuButton> createState() => _UpdatesCardMenuButtonState();
}

class _UpdatesCardMenuButtonState extends State<UpdatesCardMenuButton> {
  final MenuController _menuController = MenuController();
  bool _lastIsOpen = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store, widget.release),
      builder: (context, vm) {
        final l10n = AppLocalizations.of(context)!;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: MenuAnchor(
            controller: _menuController,
            builder: (context, controller, child) {
              final isOpen = controller.isOpen;
              if (isOpen != _lastIsOpen) {
                _lastIsOpen = isOpen;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onMenuToggle?.call(isOpen);
                });
              }
              return IconButton(
                iconSize: 16,
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
              );
            },
            menuChildren: [
              if (vm.homepage != null)
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: OpenUrlMenuItemButton(
                    label: l10n.visitHomepage,
                    url: vm.homepage!,
                    title: vm.modTitle,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
