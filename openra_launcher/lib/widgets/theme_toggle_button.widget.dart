import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mode = AdaptiveTheme.of(context).mode;

    return IconButton(
      icon: Icon(
        mode.isDark
            ? Icons.dark_mode
            : mode.isLight
                ? Icons.light_mode
                : Icons.brightness_auto,
      ),
      tooltip: 'Switch color theme',
      onPressed: () => AdaptiveTheme.of(context).toggleThemeMode(),
    );
  }
}
