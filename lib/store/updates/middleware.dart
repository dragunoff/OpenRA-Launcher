import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:openra_launcher/features/updates/domain/use_cases/get_mod_database.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';
import 'package:redux/redux.dart';

Middleware<AppState> createLoadModDatabase(
  GetModDatabase getModDatabase,
) {
  return (Store<AppState> store, action, NextDispatcher next) {
    getModDatabase(NoParams())
        .run()
        .then((database) {
      database.fold((failure) {
        store.dispatch(ModDatabaseEmptyAction());
        store.dispatch(ModDatabaseErrorAction());
      }, (database) {
        store.dispatch(database.mods.isNotEmpty
            ? ModDatabaseLoadedAction(database)
            : ModDatabaseEmptyAction());
      });
    });

    next(action);
  };
}
