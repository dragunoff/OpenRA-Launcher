import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/constants/constants.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/app_update/actions.dart';
import 'package:openra_launcher/store/mods/actions.dart';
import 'package:openra_launcher/widgets/home_screen.widget.dart';
import 'package:redux/redux.dart';

class OpenRALauncher extends StatelessWidget {
  const OpenRALauncher({Key? key, required this.store}) : super(key: key);
  final Store<AppState> store;
  final String title = Constants.appName;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
            title: title,
            // TODO: Change focus backgound color
            theme: ThemeData(
              indicatorColor: Colors.redAccent,
              colorScheme: const ColorScheme.dark(
                primary: Colors.red,
              ),
              toggleableActiveColor: Colors.redAccent,
            ),
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
            }));
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
