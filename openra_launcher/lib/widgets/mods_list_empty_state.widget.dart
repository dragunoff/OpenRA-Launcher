import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/mods/actions.dart';
import 'package:openra_launcher/widgets/empty_state.widget.dart';

class ModsListEmptyState extends StatelessWidget {
  const ModsListEmptyState({Key? key, this.listStatus = ListStatus.empty})
      : super(key: key);

  final ListStatus listStatus;
  final String emptyText = 'No installed mods found.';
  final String errorText = 'There was an error while scanning for mods.';

  @override
  Widget build(BuildContext context) {
    final hasError = listStatus == ListStatus.error;

    return EmptyState(
      text: hasError ? errorText : emptyText,
      buttonText: hasError ? 'Try again' : 'Refresh',
      buttonIcon: Icons.refresh,
      buttonOnPressed: () {
        StoreProvider.of<AppState>(context).dispatch(ReloadModsAction());
      },
    );
  }
}
