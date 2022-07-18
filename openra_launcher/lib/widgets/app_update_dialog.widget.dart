import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/constants.dart';
import 'package:openra_launcher/domain/entities/app_release.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/utils/platform_utils.dart';

class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppRelease? appRelease =
        StoreProvider.of<AppState>(context).state.appRelease;

    return AlertDialog(
      title: const Text('${Constants.appName} Update'),
      content: SingleChildScrollView(
          child: Text(
              'A new version (${appRelease?.version}) of this app is available.')),
      actions: [
        TextButton(
            onPressed: (() {
              PlatformUtils.launchUrlInExternalBrowser(appRelease?.htmlUrl)
                  .whenComplete(() => Navigator.pop(context));
            }),
            child: const Text('Go to Download')),
        TextButton(
            onPressed: (() => Navigator.pop(context)),
            child: const Text('Not Now')),
      ],
    );
  }
}
