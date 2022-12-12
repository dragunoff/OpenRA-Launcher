import 'package:openra_launcher/domain/entities/release.dart';

class LoadUpdatesAction {}

class UpdatesLoadedAction {
  final Set<Release> releases;

  UpdatesLoadedAction(this.releases);
}

class UpdatesEmptyAction {}

class UpdatesErrorAction {}
