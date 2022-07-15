import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/store/actions.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/widgets/empty_state.widget.dart';

class UpdatesListEmptyState extends StatelessWidget {
  const UpdatesListEmptyState({Key? key, this.listStatus = ListStatus.empty})
      : super(key: key);

  final ListStatus listStatus;
  final String text = 'Everything up to date.';
  final String updatesErrorText =
      'There was an error while fetching updates. Please try again later.';

  @override
  Widget build(BuildContext context) {
    final hasError = listStatus == ListStatus.error;

    return EmptyState(
      text: hasError ? updatesErrorText : text,
      buttonText: 'Check now',
      buttonIcon: Icons.refresh,
      buttonOnPressed: () {
        StoreProvider.of<AppState>(context).dispatch(LoadUpdatesAction());
      },
    );
  }
}
