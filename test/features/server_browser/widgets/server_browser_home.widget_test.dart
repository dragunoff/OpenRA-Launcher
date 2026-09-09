import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/features/server_browser/widgets/server_browser_home.widget.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/widgets/loading_state.widget.dart';
import 'package:redux/redux.dart';

void main() {
  GameServer gameServer() => const GameServer(
    id: 1,
    name: 'Red Alert #1',
    address: '127.0.0.1:6243',
    state: 1,
    ttl: 60,
    mod: 'ra',
    version: 'release-20210321',
    map: 'map-hash',
    players: 2,
    maxPlayers: 8,
    bots: 0,
    spectators: 1,
    protected: true,
    authentication: false,
    location: 'Bulgaria',
  );

  Future<void> pumpServerBrowser(WidgetTester tester, AppState state) async {
    await tester.pumpWidget(
      StoreProvider<AppState>(
        store: Store<AppState>((state, _) => state, initialState: state),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: ServerBrowserHome()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows a loading state while fetching', (tester) async {
    await tester.pumpWidget(
      StoreProvider<AppState>(
        store: Store<AppState>(
          (state, _) => state,
          initialState: AppState(serverListStatus: DataStatus.loading),
        ),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: ServerBrowserHome()),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(LoadingState), findsOneWidget);
  });

  testWidgets('shows a table with the games when loaded', (tester) async {
    await pumpServerBrowser(
      tester,
      AppState(serverListStatus: DataStatus.loaded, servers: [gameServer()]),
    );

    expect(find.byType(DataTable), findsOneWidget);
    expect(find.text('Red Alert #1'), findsOneWidget);
    expect(find.text('2/8 +1'), findsOneWidget);
    expect(find.text('Bulgaria'), findsOneWidget);
    expect(find.text('Waiting'), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  testWidgets('groups the games by mod and version', (tester) async {
    final redAlert = gameServer();

    final dune = GameServer(
      id: 2,
      name: 'Dune 2000 Lobby',
      address: '127.0.0.1:6244',
      state: 1,
      ttl: 60,
      mod: 'd2k',
      version: 'release-20250330',
      map: 'map-hash-2',
      players: 0,
      maxPlayers: 6,
      bots: 0,
      spectators: 0,
      protected: false,
      authentication: false,
      location: 'Germany',
    );

    await pumpServerBrowser(
      tester,
      AppState(serverListStatus: DataStatus.loaded, servers: [dune, redAlert]),
    );

    expect(find.byType(DataTable), findsNWidgets(2));
    expect(find.text('Red Alert'), findsOneWidget);
    expect(find.text('Dune 2000'), findsOneWidget);
    expect(find.text('[release-20210321]'), findsOneWidget);
    expect(find.text('[release-20250330]'), findsOneWidget);
    expect(find.text('Dune 2000 Lobby'), findsOneWidget);
  });

  testWidgets('shows the player count in the group header', (tester) async {
    await pumpServerBrowser(
      tester,
      AppState(serverListStatus: DataStatus.loaded, servers: [gameServer()]),
    );

    // The fixture server has 2 players and 1 spectator.
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('shows an empty state when there are no games', (tester) async {
    await pumpServerBrowser(
      tester,
      AppState(serverListStatus: DataStatus.empty),
    );

    expect(find.text('No games found.'), findsOneWidget);
  });

  testWidgets('shows an error state when fetching fails', (tester) async {
    await pumpServerBrowser(
      tester,
      AppState(serverListStatus: DataStatus.error),
    );

    expect(
      find.text(
        'There was an error while fetching games. Please try again later.',
      ),
      findsOneWidget,
    );
  });
}
