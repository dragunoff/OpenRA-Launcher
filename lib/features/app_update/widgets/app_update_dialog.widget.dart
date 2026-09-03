import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/core/platform/open_external_url.dart';
import 'package:openra_launcher/features/app_update/domain/entities/app_release.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({super.key, required this.appRelease});

  final AppRelease appRelease;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.appUpdateTitle('OpenRA Launcher')),
      content: SingleChildScrollView(
        child: Text(l10n.appUpdateBody(appRelease.version)),
      ),
      actions: [
        TextButton(
          onPressed: (() async {
            await getIt<OpenExternalUrl>()(appRelease.htmlUrl).run();

            if (context.mounted) {
              Navigator.pop(context);
            }
          }),
          child: Text(l10n.goToDownload),
        ),
        TextButton(
          onPressed: (() => Navigator.pop(context)),
          child: Text(l10n.notNow),
        ),
      ],
    );
  }
}
