import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/features/updates/widgets/release_notes_dialog.widget.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

class ReleaseNotesButton extends StatelessWidget {
  const ReleaseNotesButton({
    super.key,
    required this.release,
  });

  final Release release;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextButton.icon(
      icon: const Icon(Icons.description),
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (_) => ReleaseNotesDialog(release: release),
        );
      },
      label: Text(l10n.releaseNotes),
    );
  }
}
