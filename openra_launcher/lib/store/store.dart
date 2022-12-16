import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/middleware.dart';
import 'package:openra_launcher/store/reducer.dart';
import 'package:openra_launcher/usecases/get_installed_mods.dart';
import 'package:openra_launcher/usecases/get_latest_mod_releases.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

Future<Store<AppState>> createStore() async {
  final persistor = Persistor<AppState>(
    storage: FlutterStorage(
        key: 'openra-launcher',
        location: FlutterSaveLocation.sharedPreferences),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
  );

  final initialState = await persistor.load();

  final Store<AppState> store = Store<AppState>(
    appReducer,
    initialState: initialState ?? AppState.initial(),
    middleware: [
      ...createMiddleware(
        getInstalledMods: getIt.get<GetInstalledMods>(),
        getLatestModReleases: getIt.get<GetLatestModReleases>(),
      ),
      persistor.createMiddleware()
    ],
  );

  return store;
}
