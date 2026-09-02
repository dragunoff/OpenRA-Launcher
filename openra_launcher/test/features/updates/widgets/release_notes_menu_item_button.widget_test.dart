import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/features/updates/widgets/release_notes_dialog.widget.dart';
import 'package:openra_launcher/features/updates/widgets/release_notes_menu_item_button.widget.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

void main() {
  final testRelease = Release(
    modId: 'ra',
    id: 1,
    name: 'Red Alert',
    version: '1.0.0',
    isPlaytest: false,
    htmlUrl: 'https://example.com',
    body: '# Notes\n- Item one',
  );

  Widget buildMenu() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: MenuAnchor(
            builder: (context, controller, child) {
              return TextButton(
                onPressed: () => controller.open(),
                child: const Text('Open'),
              );
            },
            menuChildren: [
              ReleaseNotesMenuItemButton(release: testRelease),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets(
      'opening release notes from a closing menu shows the dialog without '
      'throwing', (tester) async {
    await tester.pumpWidget(buildMenu());

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(ReleaseNotesMenuItemButton), findsOneWidget);

    await tester.tap(find.text('Release notes'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(ReleaseNotesDialog), findsOneWidget);
    expect(find.text('# Notes\n- Item one'), findsNothing);
    expect(find.text('Red Alert'), findsOneWidget);
  });
}
