import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/services/mod_launch_service.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

class ModLaunchButton extends StatefulWidget {
  const ModLaunchButton({super.key, required this.mod});

  final Mod mod;

  @override
  State<ModLaunchButton> createState() => _ModLaunchButtonState();
}

class _ModLaunchButtonState extends State<ModLaunchButton> {
  bool _isLaunching = false;

  Future<void> _launchMod() async {
    final result = await getIt<ModLaunchService>().launch(widget.mod).run();

    if (!mounted || result.isRight()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.couldNotLaunchMod(widget.mod.title),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _setIsLaunching(bool isStarting) {
    setState(() {
      _isLaunching = isStarting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.rocket),
      onPressed: () async {
        if (_isLaunching) {
          return;
        }

        _setIsLaunching(true);
        _launchMod().whenComplete(
          () =>
              // NOTE: Artificial delay to give feedback that something is going on
              Timer(
                const Duration(milliseconds: 500),
                () => _setIsLaunching(false),
              ),
        );
      },
      label: Text(AppLocalizations.of(context)!.launch),
    );
  }
}
