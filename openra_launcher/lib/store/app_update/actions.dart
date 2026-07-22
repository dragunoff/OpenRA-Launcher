import 'package:openra_launcher/features/app_update/domain/entities/app_release.dart';

class LoadAppUpdateAction {}

class AppUpdateLoadedAction {
  final AppRelease release;

  AppUpdateLoadedAction(this.release);
}

class AppUpdateEmptyAction {}

class AppUpdateErrorAction {}
