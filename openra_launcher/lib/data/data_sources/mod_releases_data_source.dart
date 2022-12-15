import 'package:openra_launcher/core/error/exceptions.dart';
import 'package:openra_launcher/data/models/release_model.dart';

abstract class ModReleasesDataSource {
  /// Queries the GitHub API for releases
  /// and creates models from them.
  ///
  /// Throws a [ServerException] on error.
  Future<Set<ReleaseModel>> getModReleases();
}
