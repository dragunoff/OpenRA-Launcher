import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/features/installed_mods/widgets/open_url_menu_item_button.widget.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/features/updates/widgets/release_notes_menu_item_button.widget.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/selectors.dart';
import 'package:openra_launcher/store/updates/selectors.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  final String? homepage;
  final String? repoUrl;
  final String modTitle;

  _ViewModel({
    required this.homepage,
    required this.repoUrl,
    required this.modTitle,
  });

  static _ViewModel fromStore(Store<AppState> store, Release release) {
    return _ViewModel(
      homepage: selectModInfo(store.state, release.modId)?.homepage,
      repoUrl: selectModInfo(store.state, release.modId)?.repoUrl,
      modTitle: selectModById(store.state, release.modId).title,
    );
  }
}

class UpdatesCardMenuButton extends StatefulWidget {
  const UpdatesCardMenuButton({
    super.key,
    required this.release,
    this.onMenuToggle,
  });

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
              if (widget.release.hasReleaseNotes)
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: ReleaseNotesMenuItemButton(release: widget.release),
                ),
              if (vm.homepage != null)
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: OpenUrlMenuItemButton(
                    label: l10n.visitHomepage,
                    url: vm.homepage!,
                    title: vm.modTitle,
                  ),
                ),
              if (vm.repoUrl != null)
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: OpenUrlMenuItemButton(
                    label: l10n.viewRepository,
                    url: vm.repoUrl!,
                    title: vm.modTitle,
                    icon: Icons.code,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
