import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/features/server_browser/widgets/server_status_badge.widget.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

class ServerList extends StatelessWidget {
  const ServerList({super.key, required this.servers});

  final List<GameServer> servers;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: DataTable(
        columns: [
          DataColumn(
            label: Text(l10n.game),
            columnWidth: const FlexColumnWidth(),
          ),
          DataColumn(
            label: Text(l10n.status),
            columnWidth: const FlexColumnWidth(),
          ),
          DataColumn(
            label: Text(l10n.players),
            columnWidth: const FlexColumnWidth(),
          ),
          DataColumn(
            label: Text(l10n.location),
            columnWidth: const FlexColumnWidth(),
          ),
        ],
        rows: servers.map((server) {
          final players =
              '${server.players}/${server.maxPlayers}'
              '${server.spectators > 0 ? ' +${server.spectators}' : ''}';

          return DataRow(
            cells: [
              DataCell(_ServerNameCell(server: server)),
              DataCell(ServerStatusBadge(status: server.status)),
              DataCell(Text(players)),
              DataCell(Text(server.location ?? '—')),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ServerNameCell extends StatelessWidget {
  const _ServerNameCell({required this.server});

  final GameServer server;

  @override
  Widget build(BuildContext context) {
    final icons = <Widget>[];

    if (server.protected) {
      icons.add(const Icon(Icons.lock_outline, size: 16));
    }

    if (server.authentication) {
      icons.add(const Icon(Icons.badge_outlined, size: 16));
    }

    if (icons.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(server.name, overflow: TextOverflow.ellipsis)),
          if (icons.isNotEmpty) ...[const SizedBox(width: 4), ...icons],
        ],
      );
    }

    return Text(server.name, overflow: TextOverflow.ellipsis);
  }
}
