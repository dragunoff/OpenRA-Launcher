import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/discover/widgets/discover_home.widget.dart';
import 'package:openra_launcher/features/installed_mods/widgets/installed_mods_home.widget.dart';
import 'package:openra_launcher/features/server_browser/widgets/server_browser_home.widget.dart';
import 'package:openra_launcher/features/updates/widgets/updates_home.widget.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/widgets/home_screen.widget.dart';
import 'package:redux/redux.dart';

void main() {
  testWidgets('home screen switches content with the navigation rail', (
    tester,
  ) async {
    final store = Store<AppState>(
      (state, action) => state,
      initialState: AppState.initial(),
    );

    await tester.pumpWidget(
      StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(title: 'Test', onInit: () {}),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(InstalledModsHome), findsOneWidget);

    await tester.tap(find.text('Updates'));
    await tester.pumpAndSettle();

    expect(find.byType(UpdatesHome), findsOneWidget);
    expect(find.byType(InstalledModsHome), findsNothing);

    await tester.tap(find.text('Discover'));
    await tester.pumpAndSettle();

    expect(find.byType(DiscoverHome), findsOneWidget);
    expect(find.byType(InstalledModsHome), findsNothing);

    await tester.tap(find.text('Games'));
    await tester.pumpAndSettle();

    expect(find.byType(ServerBrowserHome), findsOneWidget);
    expect(find.byType(InstalledModsHome), findsNothing);
  });
}
