import 'package:flutter/material.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/features/app_update/domain/entities/app_release.dart';
import 'package:openra_launcher/utils/platform_utils.dart';

class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({
    Key? key,
    required this.appRelease,
  }) : super(key: key);

  final AppRelease appRelease;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('${AppConstants.appName} Update'),
      content: SingleChildScrollView(
          child: Text(
              'A new version (${appRelease.version}) of this app is available.')),
      actions: [
        TextButton(
            onPressed: (() {
              PlatformUtils.launchUrlInExternalBrowser(appRelease.htmlUrl)
                  .whenComplete(() {
                if (context.mounted) {
                  Navigator.pop(context);
                }
              });
            }),
            child: const Text('Go to Download')),
        TextButton(
            onPressed: (() => Navigator.pop(context)),
            child: const Text('Not Now')),
      ],
    );
  }
}
