import 'dart:async';

import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/server_list/actions.dart';
import 'package:openra_launcher/features/server_browser/domain/use_cases/get_server_list.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';
import 'package:redux/redux.dart';

Middleware<AppState> createLoadServerList(GetServerList getServerList) {
  return (Store<AppState> store, action, NextDispatcher next) {
    _loadServerList(getServerList, store);
    next(action);
  };
}

Middleware<AppState> createReloadServerList(GetServerList getServerList) {
  return (Store<AppState> store, action, NextDispatcher next) {
    // NOTE: Add artificial delay to give the user
    // feedback that something is going on
    Timer(const Duration(milliseconds: 300), () {
      _loadServerList(getServerList, store);
    });

    next(action);
  };
}

void _loadServerList(GetServerList getServerList, Store<AppState> store) {
  getServerList(NoParams()).run().then((servers) {
    servers.fold(
      (failure) {
        store.dispatch(ServerListErrorAction());
      },
      (servers) {
        if (servers.isEmpty) {
          store.dispatch(ServerListEmptyAction());

          return;
        }

        store.dispatch(ServerListLoadedAction(servers));
      },
    );
  });
}
