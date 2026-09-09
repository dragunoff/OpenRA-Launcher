import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/core/platform/open_external_url.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

class JoinButton extends StatefulWidget {
  const JoinButton({super.key, required this.server});

  final GameServer server;

  @override
  State<JoinButton> createState() => _JoinButtonState();
}

class _JoinButtonState extends State<JoinButton> {
  Future<void> _join() async {
    final result = await getIt<OpenExternalUrl>()(widget.server.joinUri).run();

    if (!mounted || result.isRight()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.couldNotOpenUrl(widget.server.joinUri),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _join,
      child: Text(AppLocalizations.of(context)!.join),
    );
  }
}
