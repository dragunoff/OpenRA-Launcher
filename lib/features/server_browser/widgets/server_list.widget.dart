import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server_group.dart';
import 'package:openra_launcher/features/server_browser/widgets/server_status_badge.widget.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

class ServerList extends StatelessWidget {
  const ServerList({super.key, required this.servers});

  final List<GameServer> servers;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groups = groupServersByModAndVersion(servers);

    if (groups.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final group in groups)
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ModGroupHeader(group: group),
                DataTable(
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
                  rows: [
                    for (final server in group.servers) _buildDataRow(server),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  DataRow _buildDataRow(GameServer server) {
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
  }
}

class _ModGroupHeader extends StatelessWidget {
  const _ModGroupHeader({required this.group});

  final GameServerGroup group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          if (group.iconUrl != null) ...[
            _ModIcon(url: group.iconUrl!),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              group.title,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
          ),
          Text(
            '[${group.version}]',
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.people_outline,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text('${group.playerCount}'),
        ],
      ),
    );
  }
}

class _ModIcon extends StatelessWidget {
  const _ModIcon({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox.shrink();
        },
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
