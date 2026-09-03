import 'package:material_ui/material_ui.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/services/mod_folders_service.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

enum ModFolderType { maps, replays }

class OpenModFolderMenuItemButton extends StatefulWidget {
  const OpenModFolderMenuItemButton({
    super.key,
    required this.mod,
    required this.folder,
  });

  final Mod mod;
  final ModFolderType folder;

  @override
  State<OpenModFolderMenuItemButton> createState() =>
      _OpenModFolderMenuItemButtonState();
}

class _OpenModFolderMenuItemButtonState
    extends State<OpenModFolderMenuItemButton> {
  TaskEither<PlatformFailure, Unit> _openFolder() {
    final service = getIt<ModFoldersService>();

    return widget.folder == ModFolderType.maps
        ? service.openMapsFolder(widget.mod)
        : service.openReplaysFolder(widget.mod);
  }

  Future<void> _onPressed() async {
    final result = await _openFolder().run();

    if (!mounted || result.isRight()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_buildErrorMessage(l10n)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _buildErrorMessage(AppLocalizations l10n) {
    return widget.folder == ModFolderType.maps
        ? l10n.couldNotOpenMapsFolder(widget.mod.title)
        : l10n.couldNotOpenReplaysFolder(widget.mod.title);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMaps = widget.folder == ModFolderType.maps;

    return MenuItemButton(
      leadingIcon: const Icon(Icons.folder_open),
      onPressed: _onPressed,
      child: Text(isMaps ? l10n.openMapsFolder : l10n.openReplaysFolder),
    );
  }
}
