import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:openra_launcher/constants/mod_constants.dart';
import 'package:openra_launcher/core/error/error_reporter.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/core/platform/open_external_url.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/server_browser/domain/entities/game_server.dart';
import 'package:openra_launcher/features/server_browser/widgets/server_browser_home.widget.dart';
import 'package:openra_launcher/features/server_browser/widgets/server_status_badge.widget.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/hidden_mods/actions.dart';
import 'package:openra_launcher/store/reducer.dart';
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

  GameServer emptyServer() => const GameServer(
    id: 3,
    name: 'Empty Server',
    address: '127.0.0.1:6247',
    state: 1,
    ttl: 60,
    mod: 'ra',
    version: 'release-20210321',
    map: 'map-hash',
    players: 0,
    maxPlayers: 8,
    bots: 0,
    spectators: 0,
    protected: false,
    authentication: false,
    location: 'France',
  );

  late _FakeOpenExternalUrl openExternalUrl;
  TaskEither<PlatformFailure, bool> joinResult = TaskEither.right(true);

  Set<Mod> defaultInstalledMods() => {
    const Mod(
      key: 'ra-release-20210321',
      id: 'ra',
      version: 'release-20210321',
      title: 'Red Alert',
      launchPath: '',
      launchArgs: [''],
    ),
    const Mod(
      key: 'd2k-release-20250330',
      id: 'd2k',
      version: 'release-20250330',
      title: 'Dune 2000',
      launchPath: '',
      launchArgs: [''],
    ),
    const Mod(
      key: 'ra-${ModConstants.devModVersion}',
      id: 'ra',
      version: ModConstants.devModVersion,
      title: 'Red Alert',
      launchPath: '',
      launchArgs: [''],
    ),
  };

  AppState withDefaultMods(AppState state) {
    if (state.mods.isNotEmpty) {
      return state;
    }

    return AppState(
      mods: defaultInstalledMods(),
      modDatabase: state.modDatabase,
      servers: state.servers,
      favoriteMods: state.favoriteMods,
      hiddenMods: state.hiddenMods,
      modsListStatus: state.modsListStatus,
      modDatabaseStatus: state.modDatabaseStatus,
      serverListStatus: state.serverListStatus,
      autoCheckAppUpdates: state.autoCheckAppUpdates,
      showDevMods: state.showDevMods,
      showHiddenMods: state.showHiddenMods,
      serverStatusFilter: state.serverStatusFilter,
      appRelease: state.appRelease,
    );
  }

  setUp(() {
    getIt.reset();
  });

  tearDown(() {
    getIt.reset();
  });

  Future<void> pumpServerBrowser(WidgetTester tester, AppState state) async {
    openExternalUrl = _FakeOpenExternalUrl(joinResult);
    getIt.registerSingleton<OpenExternalUrl>(openExternalUrl);

    final initialState = withDefaultMods(state);

    await tester.pumpWidget(
      StoreProvider<AppState>(
        store: Store<AppState>((state, _) => state, initialState: initialState),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: ServerBrowserHome()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpServerBrowserWithReducer(
    WidgetTester tester,
    AppState state,
  ) async {
    openExternalUrl = _FakeOpenExternalUrl(joinResult);
    getIt.registerSingleton<OpenExternalUrl>(openExternalUrl);

    final initialState = withDefaultMods(state);

    await tester.pumpWidget(
      StoreProvider<AppState>(
        store: Store<AppState>(appReducer, initialState: initialState),
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
    expect(
      find.descendant(
        of: find.byType(ServerStatusBadge),
        matching: find.text('Waiting'),
      ),
      findsOneWidget,
    );
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
      players: 2,
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
    expect(find.text('release-20210321'), findsOneWidget);
    expect(find.text('release-20250330'), findsOneWidget);
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

  testWidgets('shows a Join button for a joinable game', (tester) async {
    await pumpServerBrowser(
      tester,
      AppState(serverListStatus: DataStatus.loaded, servers: [gameServer()]),
    );

    expect(find.text('Join'), findsOneWidget);
  });

  testWidgets('hides the Join button when the game cannot be joined', (
    tester,
  ) async {
    final playing = GameServer(
      id: 2,
      name: 'Red Alert in Progress',
      address: '127.0.0.1:6245',
      state: 2,
      ttl: 60,
      mod: 'ra',
      version: 'release-20210321',
      map: 'map-hash',
      players: 4,
      maxPlayers: 8,
      bots: 0,
      spectators: 0,
      protected: false,
      authentication: false,
      location: 'Germany',
    );

    await pumpServerBrowser(
      tester,
      AppState(serverListStatus: DataStatus.loaded, servers: [playing]),
    );

    expect(find.text('Join'), findsNothing);
  });

  testWidgets('opens the join URI when pressing Join', (tester) async {
    await pumpServerBrowser(
      tester,
      AppState(serverListStatus: DataStatus.loaded, servers: [gameServer()]),
    );

    await tester.tap(find.text('Join'));
    await tester.pumpAndSettle();

    expect(openExternalUrl.urls, [
      'openra-ra-release-20210321://127.0.0.1:6243',
    ]);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('shows an error snackbar when joining fails', (tester) async {
    joinResult = TaskEither.left(const PlatformFailure('boom'));

    await pumpServerBrowser(
      tester,
      AppState(serverListStatus: DataStatus.loaded, servers: [gameServer()]),
    );

    await tester.tap(find.text('Join'));
    await tester.pumpAndSettle();

    expect(
      find.text('Could not open openra-ra-release-20210321://127.0.0.1:6243'),
      findsOneWidget,
    );
  });

  testWidgets('places favorite groups first and marks them with a star', (
    tester,
  ) async {
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
      players: 8,
      maxPlayers: 6,
      bots: 0,
      spectators: 0,
      protected: false,
      authentication: false,
      location: 'Germany',
    );

    await pumpServerBrowser(
      tester,
      AppState(
        serverListStatus: DataStatus.loaded,
        servers: [dune, redAlert],
        favoriteMods: {'ra-release-20210321'},
      ),
    );

    final redAlertTop = tester.getTopLeft(find.text('Red Alert')).dy;
    final duneTop = tester.getTopLeft(find.text('Dune 2000')).dy;

    expect(redAlertTop, lessThan(duneTop));
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('does not show a star when no group is a favorite', (
    tester,
  ) async {
    await pumpServerBrowser(
      tester,
      AppState(serverListStatus: DataStatus.loaded, servers: [gameServer()]),
    );

    expect(find.byIcon(Icons.star), findsNothing);
  });

  testWidgets('shows a dev badge for dev-mod groups', (tester) async {
    final devGame = GameServer(
      id: 3,
      name: 'Dev Lobby',
      address: '127.0.0.1:6246',
      state: 1,
      ttl: 60,
      mod: 'ra',
      version: '{DEV_VERSION}',
      map: 'map-hash',
      players: 2,
      maxPlayers: 8,
      bots: 0,
      spectators: 0,
      protected: false,
      authentication: false,
      location: 'Bulgaria',
    );

    await pumpServerBrowser(
      tester,
      AppState(serverListStatus: DataStatus.loaded, servers: [devGame]),
    );

    expect(find.text('dev'), findsOneWidget);
    expect(find.text('[{DEV_VERSION}]'), findsNothing);
    expect(find.byIcon(Icons.star), findsNothing);
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

  testWidgets('hides servers for mods that are not installed', (tester) async {
    final tiberianSun = GameServer(
      id: 4,
      name: 'Tiberian Sun Lobby',
      address: '127.0.0.1:6248',
      state: 1,
      ttl: 60,
      mod: 'ts',
      version: 'release-20230801',
      map: 'map-hash-3',
      players: 3,
      maxPlayers: 8,
      bots: 0,
      spectators: 0,
      protected: false,
      authentication: false,
      location: 'UK',
    );

    await pumpServerBrowser(
      tester,
      AppState(
        serverListStatus: DataStatus.loaded,
        servers: [gameServer(), tiberianSun],
      ),
    );

    expect(find.text('Red Alert #1'), findsOneWidget);
    expect(find.text('Tiberian Sun Lobby'), findsNothing);
    expect(find.text('Tiberian Sun'), findsNothing);
  });

  testWidgets('hides servers for hidden mods', (tester) async {
    final dune = GameServer(
      id: 2,
      name: 'Dune 2000 Lobby',
      address: '127.0.0.1:6244',
      state: 1,
      ttl: 60,
      mod: 'd2k',
      version: 'release-20250330',
      map: 'map-hash-2',
      players: 2,
      maxPlayers: 6,
      bots: 0,
      spectators: 0,
      protected: false,
      authentication: false,
      location: 'Germany',
    );

    await pumpServerBrowser(
      tester,
      AppState(
        serverListStatus: DataStatus.loaded,
        servers: [gameServer(), dune],
        hiddenMods: {'ra-release-20210321'},
      ),
    );

    expect(find.text('Red Alert #1'), findsNothing);
    expect(find.text('Dune 2000 Lobby'), findsOneWidget);
  });

  testWidgets(
    'shows servers for hidden mods with an indicator when showHiddenMods is on',
    (tester) async {
      await pumpServerBrowser(
        tester,
        AppState(
          serverListStatus: DataStatus.loaded,
          servers: [gameServer()],
          hiddenMods: {'ra-release-20210321'},
          showHiddenMods: true,
        ),
      );

      expect(find.text('Red Alert #1'), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    },
  );

  testWidgets('does not show a hidden indicator for visible mods', (
    tester,
  ) async {
    await pumpServerBrowser(
      tester,
      AppState(serverListStatus: DataStatus.loaded, servers: [gameServer()]),
    );

    expect(find.byIcon(Icons.visibility_off), findsNothing);
  });

  testWidgets('hides servers immediately after hiding a mod', (tester) async {
    final store = Store<AppState>(
      appReducer,
      initialState: withDefaultMods(
        AppState(serverListStatus: DataStatus.loaded, servers: [gameServer()]),
      ),
    );
    openExternalUrl = _FakeOpenExternalUrl(joinResult);
    getIt.registerSingleton<OpenExternalUrl>(openExternalUrl);

    await tester.pumpWidget(
      StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: ServerBrowserHome()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Red Alert #1'), findsOneWidget);

    store.dispatch(HideModAction(defaultInstalledMods().first));

    await tester.pumpAndSettle();

    expect(find.text('Red Alert #1'), findsNothing);
  });

  testWidgets('hides empty servers by default', (tester) async {
    await pumpServerBrowser(
      tester,
      AppState(
        serverListStatus: DataStatus.loaded,
        servers: [gameServer(), emptyServer()],
      ),
    );

    expect(find.text('Red Alert #1'), findsOneWidget);
    expect(find.text('Empty Server'), findsNothing);
    expect(find.byType(FilterChip), findsNWidgets(3));
  });

  testWidgets('shows empty servers when the Empty filter is enabled', (
    tester,
  ) async {
    await pumpServerBrowserWithReducer(
      tester,
      AppState(
        serverListStatus: DataStatus.loaded,
        servers: [gameServer(), emptyServer()],
      ),
    );

    await tester.tap(find.widgetWithText(FilterChip, 'Empty'));
    await tester.pumpAndSettle();

    expect(find.text('Empty Server'), findsOneWidget);
    expect(find.text('Red Alert #1'), findsOneWidget);
  });

  testWidgets('hides waiting servers when the Waiting filter is disabled', (
    tester,
  ) async {
    await pumpServerBrowserWithReducer(
      tester,
      AppState(
        serverListStatus: DataStatus.loaded,
        servers: [gameServer(), emptyServer()],
      ),
    );

    await tester.tap(find.widgetWithText(FilterChip, 'Waiting'));
    await tester.pumpAndSettle();

    expect(find.text('Red Alert #1'), findsNothing);
    expect(find.text('Empty Server'), findsNothing);
  });
}

class _FakeOpenExternalUrl implements OpenExternalUrl {
  _FakeOpenExternalUrl(this._result);

  final TaskEither<PlatformFailure, bool> _result;
  final List<String> urls = [];

  @override
  final ErrorReporter reportError = defaultErrorReporter;

  @override
  TaskEither<PlatformFailure, bool> call(String url) {
    urls.add(url);
    return _result;
  }
}
