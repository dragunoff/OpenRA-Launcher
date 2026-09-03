import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/services/mod_folders_service.dart';
import 'package:openra_launcher/features/installed_mods/widgets/open_mod_folder_menu_item_button.widget.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';

void main() {
  tearDown(() {
    getIt.reset();
  });

  Future<void> pumpButton(
    WidgetTester tester, {
    required ModFolderType folder,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: OpenModFolderMenuItemButton(
            mod: const Mod(
              key: 'test-version',
              id: 'test',
              version: 'version',
              title: 'Test Mod',
              launchPath: '',
              launchArgs: [],
            ),
            folder: folder,
          ),
        ),
      ),
    );
  }

  testWidgets('shows an error snackbar when opening the maps folder fails', (
    tester,
  ) async {
    getIt.registerSingleton<ModFoldersService>(
      _FakeModFoldersService(TaskEither.left(const PlatformFailure('boom'))),
    );

    await pumpButton(tester, folder: ModFolderType.maps);

    await tester.tap(find.text('Open maps folder'));
    await tester.pumpAndSettle();

    expect(
      find.text('Could not open the maps folder of Test Mod'),
      findsOneWidget,
    );
  });

  testWidgets('shows an error snackbar when opening the replays folder fails', (
    tester,
  ) async {
    getIt.registerSingleton<ModFoldersService>(
      _FakeModFoldersService(TaskEither.left(const PlatformFailure('boom'))),
    );

    await pumpButton(tester, folder: ModFolderType.replays);

    await tester.tap(find.text('Open replays folder'));
    await tester.pumpAndSettle();

    expect(
      find.text('Could not open the replays folder of Test Mod'),
      findsOneWidget,
    );
  });

  testWidgets('shows no snackbar when opening the folder succeeds', (
    tester,
  ) async {
    getIt.registerSingleton<ModFoldersService>(
      _FakeModFoldersService(TaskEither.right(unit)),
    );

    await pumpButton(tester, folder: ModFolderType.maps);

    await tester.tap(find.text('Open maps folder'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsNothing);
  });
}

class _FakeModFoldersService implements ModFoldersService {
  final TaskEither<PlatformFailure, Unit> _result;

  _FakeModFoldersService(this._result);

  @override
  TaskEither<PlatformFailure, Unit> openMapsFolder(Mod mod) => _result;

  @override
  TaskEither<PlatformFailure, Unit> openReplaysFolder(Mod mod) => _result;
}
