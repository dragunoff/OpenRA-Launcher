import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server_group.dart';
import 'package:openra_launcher/features/server_browser/widgets/join_button.widget.dart';
import 'package:openra_launcher/features/server_browser/widgets/server_status_badge.widget.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/widgets/card_header.widget.dart';
import 'package:openra_launcher/widgets/card_layout.widget.dart';
import 'package:openra_launcher/widgets/image_placeholder.widget.dart';

class ServerList extends StatelessWidget {
  const ServerList({
    super.key,
    required this.servers,
    this.favoriteModKeys = const {},
  });

  final List<GameServer> servers;
  final Set<String> favoriteModKeys;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groups = groupServersByModAndVersion(
      servers,
      favoriteModKeys: favoriteModKeys,
    );

    if (groups.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final group in groups)
          CardLayout(
            header: CardHeader(
              leading: group.iconUrl != null
                  ? _ModIcon(url: group.iconUrl!)
                  : const ImagePlaceholder(),
              title: group.title,
              subtitle: group.isDev ? '' : group.version,
            ),
            topRight: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (group.isFavorite) ...[
                  const Icon(Icons.star, size: 16),
                  const SizedBox(width: 8),
                ],
                const Icon(Icons.people_outline, size: 16),
                const SizedBox(width: 4),
                Text('${group.playerCount}'),
                if (group.isDev) ...[const SizedBox(width: 8), _DevBadge()],
              ],
            ),
            bottom: DataTable(
              columnSpacing: AppConstants.spacing3x,
              columns: [
                DataColumn(
                  label: Text(l10n.game),
                  columnWidth: const FlexColumnWidth(4),
                ),
                DataColumn(
                  label: Text(l10n.status),
                  columnWidth: const IntrinsicColumnWidth(),
                ),
                DataColumn(
                  label: Text(l10n.players),
                  columnWidth: const IntrinsicColumnWidth(),
                ),
                DataColumn(
                  label: Text(l10n.location),
                  columnWidth: const IntrinsicColumnWidth(),
                ),
                DataColumn(
                  label: const SizedBox.shrink(),
                  columnWidth: const FixedColumnWidth(112),
                ),
              ],
              rows: [for (final server in group.servers) _buildDataRow(server)],
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
        DataCell(
          server.isJoinable
              ? JoinButton(server: server)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _DevBadge extends StatelessWidget {
  const _DevBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        AppLocalizations.of(context)!.dev,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(server.name, overflow: TextOverflow.ellipsis)),
        if (icons.isNotEmpty) ...[const SizedBox(width: 4), ...icons],
      ],
    );
  }
}
