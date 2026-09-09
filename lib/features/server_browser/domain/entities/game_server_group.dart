import 'package:flutter/foundation.dart';
import 'package:openra_launcher/constants/mod_constants.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';

/// How many characters of a mod title fit in the group header.
const int maxModTitleLength = 50;

/// A set of servers advertised for the same mod and release, mirroring the
/// grouping used by the in-game and web server browsers.
@immutable
class GameServerGroup {
  const GameServerGroup({
    required this.title,
    required this.version,
    required this.iconUrl,
    required this.website,
    required this.playerCount,
    required this.servers,
    required this.mod,
    this.isFavorite = false,
  });

  final String title;
  final String version;
  final String? iconUrl;
  final String? website;

  /// Total number of players (and spectators) across the group.
  final int playerCount;

  final List<GameServer> servers;

  /// Stable mod identifier shared by every server in the group, used to match
  /// the group against installed mods (whose keys are `id-version`).
  final String mod;

  /// Whether the installed mod for this group is a favorite.
  final bool isFavorite;

  /// Whether the group advertises an in-development mod build.
  bool get isDev => version == ModConstants.devModVersion;

  String get favoriteKey => '$mod-$version';
}

/// Groups the given servers by mod and release.
///
/// Groups are split into three sections like the installed mods list —
/// favorites, everything else, and dev builds — and ordered by total player
/// count (most played first) within each section, matching the web and in-game
/// server browsers. Servers within each group are sorted the way the in-game
/// browser does: games waiting for players first, then games with spectators,
/// then games in progress, and finally empty servers. Games in progress are
/// ordered by when they started, everything else by the number of players.
List<GameServerGroup> groupServersByModAndVersion(
  List<GameServer> servers, {
  Set<String> favoriteModKeys = const {},
}) {
  final groups = <String, List<GameServer>>{};

  for (final server in servers) {
    final title = modTitleFor(server);
    final key = '$title-${server.version}';
    groups.putIfAbsent(key, () => []).add(server);
  }

  final result = groups.entries.map((entry) {
    final groupServers = [...entry.value]..sort(_compareServers);
    final server = groupServers.first;

    return GameServerGroup(
      title: modTitleFor(server),
      version: server.version,
      iconUrl: server.modIcon32,
      website: server.modWebsite,
      playerCount: groupServers.fold(
        0,
        (total, s) => total + s.players + s.spectators,
      ),
      mod: server.mod,
      isFavorite: favoriteModKeys.contains('${server.mod}-${server.version}'),
      servers: groupServers,
    );
  }).toList()..sort(_compareGroups);

  return result;
}

/// Orders the groups like the installed mods list: favorites, then the rest,
/// then dev builds, each section ordered by total player count, most played
/// first.
int _compareGroups(GameServerGroup a, GameServerGroup b) {
  final sectionOrder = _groupSection(a).compareTo(_groupSection(b));
  if (sectionOrder != 0) {
    return sectionOrder;
  }

  return b.playerCount.compareTo(a.playerCount);
}

/// `0` favorites, `1` everything else, `2` dev builds. Favorited dev builds
/// belong to the favorites section, mirroring the installed mods list.
int _groupSection(GameServerGroup group) {
  if (group.isFavorite) {
    return 0;
  }

  if (group.isDev) {
    return 2;
  }

  return 1;
}

/// Resolves the display title for a server's mod, falling back to a known
/// default for older official mods that did not advertise metadata.
String modTitleFor(GameServer server) {
  final title = server.modTitle;
  if (title != null && title.isNotEmpty) {
    return title.length <= maxModTitleLength
        ? title
        : title.substring(0, maxModTitleLength);
  }

  return switch (server.mod) {
    'ra' => 'Red Alert',
    'cnc' => 'Tiberian Dawn',
    'd2k' => 'Dune 2000',
    final mod => 'Unknown Mod "$mod"',
  };
}

/// Ordering keys mirror the in-game server list:
///
///  * `0` — games waiting for players
///  * `1` — games waiting with only spectators
///  * `2` — games already in progress
///  * `3` — empty servers
int _groupOrderKey(GameServer server) {
  if (server.state == 1) {
    if (server.players > 0) {
      return 0;
    }

    if (server.spectators > 0) {
      return 1;
    }

    return 3;
  }

  if (server.state >= 2) {
    return 2;
  }

  return 3;
}

int _compareServers(GameServer a, GameServer b) {
  final orderKey = _groupOrderKey(a).compareTo(_groupOrderKey(b));
  if (orderKey != 0) {
    return orderKey;
  }

  if (_groupOrderKey(a) == 2) {
    return (b.started ?? '').compareTo(a.started ?? '');
  }

  return b.players.compareTo(a.players);
}
