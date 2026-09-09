import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

class ServerStatusFilter extends StatelessWidget {
  const ServerStatusFilter({
    super.key,
    required this.visibleStatuses,
    required this.onChanged,
  });

  final Set<GameServerStatus> visibleStatuses;
  final void Function(GameServerStatus status) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    String label(GameServerStatus status) => switch (status) {
      GameServerStatus.waiting => l10n.gameStatusWaiting,
      GameServerStatus.playing => l10n.gameStatusPlaying,
      GameServerStatus.empty => l10n.gameStatusEmpty,
    };

    return Row(
      children: [
        for (final status in GameServerStatus.values) ...[
          FilterChip(
            label: Text(label(status)),
            selected: visibleStatuses.contains(status),
            onSelected: (_) => onChanged(status),
          ),
          if (status != GameServerStatus.empty) const SizedBox(width: 8),
        ],
      ],
    );
  }
}
