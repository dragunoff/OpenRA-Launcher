import 'package:openra_launcher/core/platform/get_package_info.dart';
import 'package:openra_launcher/features/app_update/use_cases/get_latest_app_release.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/middleware.dart';
import 'package:openra_launcher/store/reducer.dart';
import 'package:openra_launcher/features/installed_mods/domain/use_cases/get_installed_mods.dart';
import 'package:openra_launcher/features/updates/domain/use_cases/get_mod_database.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

Future<Store<AppState>> createStore() async {
  final persistor = Persistor<AppState>(
    storage: FlutterStorage(
      key: 'openra-launcher',
      location: FlutterSaveLocation.sharedPreferences,
    ),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
  );

  final initialState = await persistor.load();

  final Store<AppState> store = Store<AppState>(
    appReducer,
    initialState: initialState ?? AppState.initial(),
    middleware: [
      ...createMiddleware(
        getInstalledMods: getIt.get<GetInstalledMods>(),
        getModDatabase: getIt.get<GetModDatabase>(),
        getLatestAppRelease: getIt.get<GetLatestAppRelease>(),
        getPackageInfo: getIt.get<GetPackageInfo>(),
      ),
      persistor.createMiddleware(),
    ],
  );

  return store;
}
