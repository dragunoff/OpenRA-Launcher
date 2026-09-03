import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/widgets/open_url_menu_item_button.widget.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database_info.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/features/updates/widgets/updates_card_menu_button.widget.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:redux/redux.dart';

void main() {
  final mod = Mod(
    key: 'ra-version',
    id: 'ra',
    version: '1.0.0',
    title: 'Red Alert',
    launchPath: '',
    launchArgs: const [],
  );

  final release = Release(
    modId: 'ra',
    id: 1,
    version: '1.0.0',
    name: 'Red Alert',
    isPlaytest: false,
    htmlUrl: 'https://example.com',
  );

  AppState stateWithLinks() => AppState(
        mods: {mod},
        modDatabase: ModDatabase(mods: {
          'ra': ModDatabaseInfo(
            modId: 'ra',
            title: 'Red Alert',
            homepage: 'https://example.com',
            repoUrl: 'https://github.com/OpenRA/OpenRA',
          ),
        }),
      );

  Widget buildMenu({required AppState state}) {
    final store = Store<AppState>(
      (s, a) => s,
      initialState: state,
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: UpdatesCardMenuButton(release: release),
          ),
        ),
      ),
    );
  }

  Future<void> openMenu(WidgetTester tester) async {
    await tester.tap(find.byType(UpdatesCardMenuButton));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the homepage and repository items when links are present',
      (tester) async {
    await tester.pumpWidget(buildMenu(state: stateWithLinks()));

    await openMenu(tester);

    expect(find.byType(OpenUrlMenuItemButton), findsNWidgets(2));
    expect(find.text('Visit homepage'), findsOneWidget);
    expect(find.text('View repository'), findsOneWidget);
  });

  testWidgets('hides the link items when no links are present', (tester) async {
    await tester.pumpWidget(buildMenu(state: AppState(mods: {mod})));

    await openMenu(tester);

    expect(find.byType(OpenUrlMenuItemButton), findsNothing);
  });
}
