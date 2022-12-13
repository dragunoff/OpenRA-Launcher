import 'package:flutter/material.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/middleware.dart';
import 'package:openra_launcher/store/reducer.dart';
import 'package:openra_launcher/usecases/get_installed_mods.dart';
import 'package:openra_launcher/widgets/app.widget.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

Future<void> main() async {
  // Init dependency injection
  configureDependencies();

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
      ...createMiddleware(getIt.get<GetInstalledMods>()),
      persistor.createMiddleware()
    ],
  );

  runApp(OpenRALauncher(store: store));
}
