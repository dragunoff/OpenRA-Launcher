import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/core/platform/open_external_url.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

class OpenUrlMenuItemButton extends StatefulWidget {
  const OpenUrlMenuItemButton({
    super.key,
    required this.label,
    required this.url,
    this.title,
    this.icon = Icons.open_in_new,
  });

  final String label;
  final String url;
  final String? title;
  final IconData icon;

  @override
  State<OpenUrlMenuItemButton> createState() => _OpenUrlMenuItemButtonState();
}

class _OpenUrlMenuItemButtonState extends State<OpenUrlMenuItemButton> {
  Future<void> _onPressed() async {
    final result =
        await getIt<OpenExternalUrl>()(widget.url).run();

    if (!mounted || result.isRight()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final title = widget.title ?? widget.url;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.couldNotOpenUrl(title)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      leadingIcon: Icon(widget.icon),
      onPressed: _onPressed,
      child: Text(widget.label),
    );
  }
}
