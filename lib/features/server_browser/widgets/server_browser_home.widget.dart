import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/features/server_browser/widgets/server_list.widget.dart';
import 'package:openra_launcher/features/server_browser/widgets/server_list_empty_state.widget.dart';
import 'package:openra_launcher/features/server_browser/widgets/server_status_filter.widget.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/collapsed_mod_groups/actions.dart';
import 'package:openra_launcher/store/server_list/actions.dart';
import 'package:openra_launcher/store/server_status_filter/actions.dart';
import 'package:openra_launcher/widgets/loading_state.widget.dart';
import 'package:openra_launcher/widgets/page_layout.widget.dart';
import 'package:redux/redux.dart';

class ServerBrowserHome extends StatelessWidget {
  const ServerBrowserHome({super.key});

  @override
  Widget build(context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        final l10n = AppLocalizations.of(context)!;

        if (vm.serverListStatus == DataStatus.loading) {
          return LoadingState(text: l10n.fetchingServers);
        }

        if (vm.serverListStatus == DataStatus.empty ||
            vm.serverListStatus == DataStatus.error) {
          return ServerListEmptyState(listStatus: vm.serverListStatus);
        }

        final visibleServers = vm.servers.where((server) {
          final key = '${server.mod}-${server.version}';
          if (!vm.visibleStatuses.contains(server.status)) {
            return false;
          }
          if (vm.hiddenModKeys.contains(key)) {
            return false;
          }
          return vm.installedModKeys.contains(key);
        }).toList();

        return PageLayout(
          header: PageLayoutHeader(
            title: l10n.servers,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppConstants.spacing,
              children: [
                ServerStatusFilter(
                  visibleStatuses: vm.visibleStatuses,
                  onChanged: vm.toggleStatusFilter,
                ),
                TextButton.icon(
                  onPressed: vm.reloadServerList,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.refresh),
                ),
              ],
            ),
          ),
          children: [
            ServerList(
              servers: visibleServers,
              favoriteModKeys: vm.favoriteModKeys,
              collapsedModKeys: vm.collapsedModGroups,
              onToggleCollapsed: vm.toggleCollapsedModGroup,
            ),
          ],
        );
      },
    );
  }
}

class _ViewModel {
  final List<GameServer> servers;
  final Set<String> favoriteModKeys;
  final DataStatus serverListStatus;
  final Set<GameServerStatus> visibleStatuses;
  final Set<String> installedModKeys;
  final Set<String> hiddenModKeys;
  final Set<String> collapsedModGroups;
  final VoidCallback reloadServerList;
  final void Function(GameServerStatus status) toggleStatusFilter;
  final void Function(String groupKey) toggleCollapsedModGroup;

  _ViewModel({
    required this.servers,
    required this.favoriteModKeys,
    required this.serverListStatus,
    required this.visibleStatuses,
    required this.installedModKeys,
    required this.hiddenModKeys,
    required this.collapsedModGroups,
    required this.reloadServerList,
    required this.toggleStatusFilter,
    required this.toggleCollapsedModGroup,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      servers: store.state.servers,
      favoriteModKeys: store.state.favoriteMods,
      serverListStatus: store.state.serverListStatus,
      visibleStatuses: store.state.serverStatusFilter,
      installedModKeys: store.state.mods.map((mod) => mod.key).toSet(),
      hiddenModKeys: store.state.hiddenMods,
      collapsedModGroups: store.state.collapsedModGroups,
      reloadServerList: () => store.dispatch(ReloadServerListAction()),
      toggleStatusFilter: (status) =>
          store.dispatch(ToggleServerStatusFilterAction(status)),
      toggleCollapsedModGroup: (groupKey) =>
          store.dispatch(ToggleCollapsedModGroupAction(groupKey)),
    );
  }
}
