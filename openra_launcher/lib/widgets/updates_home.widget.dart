import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/domain/entities/release.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/selectors.dart';
import 'package:openra_launcher/widgets/loading_state.widget.dart';
import 'package:openra_launcher/widgets/updates_list_empty_state.widget.dart';
import 'package:openra_launcher/widgets/list_divider.widget.dart';
import 'package:openra_launcher/widgets/updates_list.widget.dart';
import 'package:redux/redux.dart';

class UpdatesHome extends StatelessWidget {
  const UpdatesHome({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          if (vm.modsListStatus == ListStatus.loading) {
            return const LoadingState(text: 'Scannig for installed mods...');
          } else if (vm.updatesListStatus == ListStatus.loading) {
            return const LoadingState(text: 'Checking for updates...');
          }

          if (vm.updatesListStatus == ListStatus.empty ||
              vm.updatesListStatus == ListStatus.error) {
            return UpdatesListEmptyState(listStatus: vm.updatesListStatus);
          }

          final List<Widget> children = [];

          if (vm.releases.isNotEmpty) {
            children.add(const ListDivider('Release available'));
            children.add(UpdatesList(releases: vm.releases));
          }

          if (vm.playtests.isNotEmpty) {
            children.add(const ListDivider('Playtest available'));
            children.add(UpdatesList(releases: vm.playtests));
          }

          return SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children));
        });
  }
}

class _ViewModel {
  final Set<Release> releases;
  final Set<Release> playtests;
  final ListStatus modsListStatus;
  final ListStatus updatesListStatus;

  _ViewModel({
    required this.releases,
    required this.playtests,
    required this.modsListStatus,
    required this.updatesListStatus,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      releases: selectReleaseUpdates(store.state),
      playtests: selectPlaytestUpdates(store.state),
      modsListStatus: store.state.modsListStatus,
      updatesListStatus: store.state.updatesListStatus,
    );
  }
}
