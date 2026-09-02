import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

class ReleaseNotesDialog extends StatelessWidget {
  const ReleaseNotesDialog({
    super.key,
    required this.release,
  });

  final Release release;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final body = release.body?.trim() ?? '';
    final hasBody = release.hasBody;

    return AlertDialog(
      title: Text(
        release.name.isNotEmpty ? release.name : l10n.releaseNotes,
      ),
      content: SingleChildScrollView(
        child: hasBody
            ? MarkdownBody(
                data: body,
                selectable: true,
              )
            : Text(l10n.noReleaseNotes),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}