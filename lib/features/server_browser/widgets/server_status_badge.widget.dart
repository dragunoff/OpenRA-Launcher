import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

class ServerStatusBadge extends StatelessWidget {
  const ServerStatusBadge({super.key, required this.status});

  final GameServerStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final label = switch (status) {
      GameServerStatus.waiting => l10n.gameStatusWaiting,
      GameServerStatus.playing => l10n.gameStatusPlaying,
      GameServerStatus.empty => l10n.gameStatusEmpty,
    };

    final color = switch (status) {
      GameServerStatus.waiting => Colors.green,
      GameServerStatus.playing => Colors.redAccent,
      GameServerStatus.empty => Colors.grey,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
