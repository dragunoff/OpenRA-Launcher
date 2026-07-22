import 'package:openra_launcher/features/updates/domain/entities/release.dart';

class LoadUpdatesAction {}

class UpdatesLoadedAction {
  final Set<Release> releases;

  UpdatesLoadedAction(this.releases);
}

class UpdatesEmptyAction {}

class UpdatesErrorAction {}
