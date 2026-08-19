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
import 'package:openra_launcher/widgets/home_screen.widget.dart';
import 'package:redux/redux.dart';

class OpenRALauncher extends StatelessWidget {
  const OpenRALauncher({Key? key, required this.store, this.savedThemeMode})
      : super(key: key);
  final Store<AppState> store;
  final String title = AppConstants.appName;
  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child: AdaptiveTheme(
          light: ThemeData.light(),
          dark: ThemeData.dark(),
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
              supportedLocales: const [
                Locale('en'),
              ],
              initialRoute: '/',
              routes: {
                '/': (context) => StoreConnector<AppState, _ViewModel>(
                      converter: _ViewModel.fromStore,
                      builder: ((context, vm) {
                        return HomeScreen(
                          title: title,
                          onInit: () {
                            vm.loadMods();
                            vm.loadAppUpdate();
                          },
                        );
                      }),
                    ),
              }),
        ));
  }
}

class _ViewModel {
  final VoidCallback loadMods;
  final VoidCallback loadAppUpdate;

  _ViewModel({
    required this.loadMods,
    required this.loadAppUpdate,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      loadMods: () => store.dispatch(LoadModsAction()),
      loadAppUpdate: () => store.dispatch(LoadAppUpdateAction()),
    );
  }
}
