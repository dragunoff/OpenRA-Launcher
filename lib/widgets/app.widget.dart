import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations, GlobalCupertinoLocalizations;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/app_update/actions.dart';
import 'package:openra_launcher/store/installed_mods/actions.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:openra_launcher/widgets/home_screen.widget.dart';
import 'package:redux/redux.dart';

TextStyle _chipLabelStyle(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: Colors.red,
    brightness: brightness,
  );
  return AppConstants.chipTextStyle.copyWith(color: scheme.onSurfaceVariant);
}

class OpenRALauncher extends StatelessWidget {
  const OpenRALauncher({super.key, required this.store, this.savedThemeMode});
  final Store<AppState> store;
  final String title = AppConstants.appName;
  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: AdaptiveTheme(
        light: ThemeData(
          colorSchemeSeed: Colors.red,
          brightness: Brightness.light,
          cardTheme: CardThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: UnderlineInputBorder(borderSide: BorderSide()),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide()),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide()),
            errorBorder: UnderlineInputBorder(borderSide: BorderSide()),
          ),
          chipTheme: ChipThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            labelStyle: _chipLabelStyle(Brightness.light),
          ),
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          bottomSheetTheme: BottomSheetThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          navigationBarTheme: NavigationBarThemeData(
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          navigationRailTheme: NavigationRailThemeData(
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          segmentedButtonTheme: SegmentedButtonThemeData(
            style: SegmentedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        dark: ThemeData(
          colorSchemeSeed: Colors.red,
          brightness: Brightness.dark,
          cardTheme: CardThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: UnderlineInputBorder(borderSide: BorderSide()),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide()),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide()),
            errorBorder: UnderlineInputBorder(borderSide: BorderSide()),
          ),
          chipTheme: ChipThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            labelStyle: _chipLabelStyle(Brightness.dark),
          ),
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          bottomSheetTheme: BottomSheetThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          navigationBarTheme: NavigationBarThemeData(
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          navigationRailTheme: NavigationRailThemeData(
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
          title: title,
          theme: theme,
          darkTheme: darkTheme,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          initialRoute: '/',
          routes: {
            '/': (context) => StoreConnector<AppState, _ViewModel>(
              converter: _ViewModel.fromStore,
              builder: ((context, vm) {
                return HomeScreen(
                  title: title,
                  onInit: () {
                    vm.loadInstalledMods();
                    vm.loadAppUpdate();
                    vm.loadModDatabase();
                  },
                );
              }),
            ),
          },
        ),
      ),
    );
  }
}

class _ViewModel {
  final VoidCallback loadInstalledMods;
  final VoidCallback loadAppUpdate;
  final VoidCallback loadModDatabase;

  _ViewModel({
    required this.loadInstalledMods,
    required this.loadAppUpdate,
    required this.loadModDatabase,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      loadInstalledMods: () => store.dispatch(LoadModsAction()),
      loadAppUpdate: () => store.dispatch(LoadAppUpdateAction()),
      loadModDatabase: () => store.dispatch(LoadModDatabaseAction()),
    );
  }
}
