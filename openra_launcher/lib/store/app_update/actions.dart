import 'package:openra_launcher/domain/entities/app_release.dart';

class LoadAppUpdateAction {}

class AppUpdateLoadedAction {
  final AppRelease release;

  AppUpdateLoadedAction(this.release);
}

class AppUpdateEmptyAction {}

class AppUpdateErrorAction {}
