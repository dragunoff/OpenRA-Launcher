import 'package:fpdart/fpdart.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/constants/mod_constants.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/services/mod_launch_service.dart';
import 'package:openra_launcher/features/installed_mods/widgets/installed_mods_card.widget.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/l10n/app_localizations.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:redux/redux.dart';

void main() {
  Mod mod(String version, {String id = 'ra'}) => Mod(
    key: '$id-$version',
    id: id,
    version: version,
    title: 'Test Mod',
    launchPath: '/launch',
    launchArgs: const [''],
  );

  tearDown(() {
    getIt.reset();
  });

  Future<void> pumpCard(WidgetTester tester, Mod mod) async {
    getIt.registerSingleton<ModLaunchService>(_FakeModLaunchService());

    await tester.pumpWidget(
      StoreProvider<AppState>(
        store: Store<AppState>((state, _) => state, initialState: AppState()),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(child: InstalledModsCard(mod: mod)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows DEV VERSION label for a dev mod', (tester) async {
    await pumpCard(tester, mod(ModConstants.devModVersion));

    expect(find.text(ModConstants.devModVersion), findsNothing);
    expect(find.text('DEV VERSION'), findsOneWidget);
  });

  testWidgets('shows version string for a normal mod', (tester) async {
    await pumpCard(tester, mod('1.0.0'));

    expect(find.text('1.0.0'), findsOneWidget);
  });
}

class _FakeModLaunchService implements ModLaunchService {
  @override
  TaskEither<PlatformFailure, Unit> launch(Mod mod) => TaskEither.right(unit);
}
