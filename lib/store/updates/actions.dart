import 'package:openra_launcher/features/updates/domain/entities/mod_database.dart';

class LoadModDatabaseAction {}

class ModDatabaseLoadedAction {
  final ModDatabase database;

  ModDatabaseLoadedAction(this.database);
}

class ModDatabaseEmptyAction {}

class ModDatabaseErrorAction {}
