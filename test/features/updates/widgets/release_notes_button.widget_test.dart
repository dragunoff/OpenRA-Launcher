import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/features/updates/widgets/release_notes_button.widget.dart';
import 'package:openra_launcher/features/updates/widgets/release_notes_dialog.widget.dart';
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

  Widget buildButton() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(child: ReleaseNotesButton(release: testRelease)),
      ),
    );
  }

  testWidgets('pressing the button shows the release notes dialog', (
    tester,
  ) async {
    await tester.pumpWidget(buildButton());

    expect(find.text('Release notes'), findsOneWidget);

    await tester.tap(find.byType(ReleaseNotesButton));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(ReleaseNotesDialog), findsOneWidget);
    expect(find.text('# Notes\n- Item one'), findsNothing);
    expect(find.text('Red Alert'), findsOneWidget);
  });
}
