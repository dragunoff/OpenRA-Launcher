import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/features/updates/widgets/release_notes_dialog.widget.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

class ReleaseNotesMenuItemButton extends StatefulWidget {
  const ReleaseNotesMenuItemButton({
    super.key,
    required this.release,
  });

  final Release release;

  @override
  State<ReleaseNotesMenuItemButton> createState() =>
      _ReleaseNotesMenuItemButtonState();
}

class _ReleaseNotesMenuItemButtonState extends State<ReleaseNotesMenuItemButton> {
  NavigatorState? _navigator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigator = Navigator.of(context);
  }

  void _onPressed() {
    final navigator = _navigator;
    if (navigator == null) {
      return;
    }

    showDialog<void>(
      context: navigator.context,
      builder: (_) => ReleaseNotesDialog(release: widget.release),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MenuItemButton(
      leadingIcon: const Icon(Icons.description),
      onPressed: _onPressed,
      child: Text(l10n.releaseNotes),
    );
  }
}
