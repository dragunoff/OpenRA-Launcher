import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/features/updates/widgets/release_notes_menu_item_button.widget.dart';
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

  Release releaseWithNotes({String name = '', String? body}) => Release(
        modId: 'ra',
        id: 1,
        version: '1.0.0',
        name: name,
        isPlaytest: false,
        htmlUrl: 'https://example.com',
        body: body,
      );

  Widget buildMenu({required AppState state, required Release release}) {
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

  testWidgets('shows the release notes item when the release has a body',
      (tester) async {
    final state = AppState(mods: {mod});
    await tester
        .pumpWidget(buildMenu(state: state, release: releaseWithNotes(body: 'x')));

    await openMenu(tester);

    expect(find.byType(ReleaseNotesMenuItemButton), findsOneWidget);
  });

  testWidgets('shows the release notes item when the release has only a name',
      (tester) async {
    final state = AppState(mods: {mod});
    await tester
        .pumpWidget(buildMenu(state: state, release: releaseWithNotes(name: 'RA')));

    await openMenu(tester);

    expect(find.byType(ReleaseNotesMenuItemButton), findsOneWidget);
  });

  testWidgets(
      'hides the release notes item when the release has neither a name nor '
      'a body', (tester) async {
    final state = AppState(mods: {mod});
    await tester.pumpWidget(
        buildMenu(state: state, release: releaseWithNotes()));

    await openMenu(tester);

    expect(find.byType(ReleaseNotesMenuItemButton), findsNothing);
  });
}
