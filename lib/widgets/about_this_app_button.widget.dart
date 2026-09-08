import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/core/platform/get_package_info.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

class AboutThisAppButton extends StatelessWidget {
  const AboutThisAppButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return IconButton(
      icon: const Icon(Icons.info_outline),
      tooltip: l10n.aboutThisApp,
      onPressed: () async {
        final packageInfo = await getIt<GetPackageInfo>()(NoParams()).run();

        if (context.mounted) {
          showAboutDialog(
            context: context,
            applicationName: AppConstants.appName,
            applicationVersion: packageInfo.version,
            applicationLegalese: l10n.appLegalese,
          );
        }
      },
    );
  }
}
