import 'package:openra_launcher/data/models/mod_model.dart';

abstract class InstalledModsDataSource {
  /// Scans the support dirs for mod metadata files
  /// and creates mod models from them.
  ///
  /// Throws a [FileSystemException] for all error codes.
  Future<Set<ModModel>> getInstalledMods();
}

// class InstalledModsDataSourceImpl implements InstalledModsDataSource {
//   @override
//   Future<ModModel> getInstalledMods() {};
// }
