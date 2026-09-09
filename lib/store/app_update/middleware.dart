import 'package:openra_launcher/core/platform/get_package_info.dart';
import 'package:openra_launcher/core/version_service.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';
import 'package:openra_launcher/features/app_update/use_cases/get_latest_app_release.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/app_update/actions.dart';
import 'package:redux/redux.dart';

Middleware<AppState> createLoadAppUpdate(
  GetLatestAppRelease getLatestAppRelease,
  GetPackageInfo getPackageInfo,
  VersionService versionService,
) {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (!store.state.autoCheckAppUpdates) {
      return;
    }

    getLatestAppRelease(NoParams()).run().then((result) {
      result.fold(
        (failure) {
          store.dispatch(AppUpdateErrorAction());
        },
        (release) async {
          final packageInfo = await getPackageInfo(NoParams()).run();

          if (versionService.isNewerVersion(
            release.version,
            packageInfo.version,
          )) {
            store.dispatch(AppUpdateLoadedAction(release));
          } else {
            store.dispatch(AppUpdateEmptyAction());
          }
        },
      );
    });

    next(action);
  };
}
