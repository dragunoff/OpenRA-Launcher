import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:openra_launcher/data/models/app_release_model.dart';
import 'package:openra_launcher/domain/entities/app_release.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/app_update/actions.dart';
import 'package:openra_launcher/utils/platform_utils.dart';
import 'package:openra_launcher/utils/release_utils.dart';
import 'package:redux/redux.dart';

Middleware<AppState> createLoadAppUpdate() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (!store.state.autoCheckAppUpdates) {
      return;
    }

    ReleaseUtils.fetchLatestAppRelease().then((rawResponse) async {
      final packageInfo = await PlatformUtils.getPackageInfo();
      final responseBody = jsonDecode(rawResponse.body) as Map<String, dynamic>;

      if (!responseBody.containsKey('message')) {
        AppRelease release = AppReleaseModel.fromJson(responseBody);

        if (release.version != packageInfo.version) {
          store.dispatch(AppUpdateLoadedAction(release));
        } else {
          store.dispatch(AppUpdateEmptyAction());
        }
      } else {
        store.dispatch(AppUpdateEmptyAction());
      }
    }).catchError((e) {
      store.dispatch(AppUpdateErrorAction());
      debugPrint('Error fetching app updates: ${e.toString()}');
    });

    next(action);
  };
}
