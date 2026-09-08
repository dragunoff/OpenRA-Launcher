import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/widgets/settings_dialog.widget.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return IconButton(
      icon: const Icon(Icons.settings),
      tooltip: l10n.settings,
      onPressed: () => showDialog(
        context: context,
        builder: (context) => const SettingsDialog(),
      ),
    );
  }
}
