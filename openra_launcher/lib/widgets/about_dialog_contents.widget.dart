import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/auto_check_app_updates/actions.dart';
import 'package:redux/redux.dart';

class AboutDialogContents extends StatelessWidget {
  const AboutDialogContents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: ((context, vm) {
        return CheckboxListTile(
          title: const Text('Check for app updates on statup'),
          controlAffinity: ListTileControlAffinity.leading,
          value: vm.checkFoUpdates,
          onChanged: (value) {
            if (value == true) {
              vm.autoCheckForAppUpdatesOn();
            } else {
              vm.autoCheckForAppUpdatesOff();
            }
          },
        );
      }),
    );
  }
}

class _ViewModel {
  final VoidCallback autoCheckForAppUpdatesOn;
  final VoidCallback autoCheckForAppUpdatesOff;
  final bool checkFoUpdates;

  _ViewModel({
    required this.autoCheckForAppUpdatesOn,
    required this.autoCheckForAppUpdatesOff,
    required this.checkFoUpdates,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      autoCheckForAppUpdatesOn: () =>
          store.dispatch(AutoCheckForAppUpdatesOn()),
      autoCheckForAppUpdatesOff: () =>
          store.dispatch(AutoCheckForAppUpdatesOff()),
      checkFoUpdates: store.state.autoCheckAppUpdates,
    );
  }
}
