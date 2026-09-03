import 'package:openra_launcher/features/updates/domain/entities/mod_database.dart';
import 'package:openra_launcher/store/updates/actions.dart';
import 'package:redux/redux.dart';

final Reducer<ModDatabase> modDatabaseReducer = combineReducers([
  TypedReducer<ModDatabase, ModDatabaseLoadedAction>(_setLoadedDatabase).call,
  TypedReducer<ModDatabase, ModDatabaseEmptyAction>(_setEmptyDatabase).call,
  TypedReducer<ModDatabase, ModDatabaseErrorAction>(_setEmptyDatabase).call,
]);

ModDatabase _setLoadedDatabase(
  ModDatabase database,
  ModDatabaseLoadedAction action,
) {
  return action.database;
}

ModDatabase _setEmptyDatabase(ModDatabase database, action) {
  return const ModDatabase(mods: {});
}
