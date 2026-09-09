import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/server_status_filter/actions.dart';
import 'package:openra_launcher/store/server_status_filter/reducer.dart';

void main() {
  group('serverStatusFilterReducer', () {
    test('toggles status off when currently visible', () {
      final state = <GameServerStatus>{
        GameServerStatus.waiting,
        GameServerStatus.playing,
      };
      final action = ToggleServerStatusFilterAction(GameServerStatus.waiting);

      final next = serverStatusFilterReducer(state, action);

      expect(next, {GameServerStatus.playing});
    });

    test('toggles status on when currently hidden', () {
      final state = <GameServerStatus>{GameServerStatus.playing};
      final action = ToggleServerStatusFilterAction(GameServerStatus.empty);

      final next = serverStatusFilterReducer(state, action);

      expect(next, {GameServerStatus.playing, GameServerStatus.empty});
    });

    test('returns an unmodifiable set', () {
      final state = <GameServerStatus>{GameServerStatus.playing};
      final action = ToggleServerStatusFilterAction(GameServerStatus.waiting);

      final next = serverStatusFilterReducer(state, action);

      expect(
        () => next.add(GameServerStatus.empty),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('does not mutate the original state', () {
      final state = <GameServerStatus>{
        GameServerStatus.waiting,
        GameServerStatus.playing,
      };
      final action = ToggleServerStatusFilterAction(GameServerStatus.waiting);

      serverStatusFilterReducer(state, action);

      expect(state, {GameServerStatus.waiting, GameServerStatus.playing});
    });
  });

  group('AppState serverStatusFilter serialization', () {
    test('toJson contains the current filter', () {
      final state = AppState(
        serverStatusFilter: {GameServerStatus.playing, GameServerStatus.empty},
      );

      final json = state.toJson();

      expect(json['serverStatusFilter'], containsAll(['playing', 'empty']));
    });

    test('fromJson restores the saved filter', () {
      final json = {
        'serverStatusFilter': ['playing', 'empty'],
      };

      final state = AppState.fromJson(json);

      expect(state!.serverStatusFilter, {
        GameServerStatus.playing,
        GameServerStatus.empty,
      });
    });

    test('fromJson defaults to waiting + playing when key is absent', () {
      final state = AppState.fromJson({});

      expect(state!.serverStatusFilter, {
        GameServerStatus.waiting,
        GameServerStatus.playing,
      });
    });

    test('fromJson defaults to waiting + playing when the key is null', () {
      final state = AppState.fromJson({'serverStatusFilter': null});

      expect(state!.serverStatusFilter, {
        GameServerStatus.waiting,
        GameServerStatus.playing,
      });
    });
  });
}
