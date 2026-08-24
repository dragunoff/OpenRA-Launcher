import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/installed_mods/domain/entities/mod.dart';
import 'package:openra_launcher/features/installed_mods/widgets/mod_release_info_chips.widget.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
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

  Release rel(int id, String version, {bool isPlaytest = false}) => Release(
        modId: 'ra',
        id: id,
        name: '${isPlaytest ? 'Playtest' : 'Release'} $version',
        version: version,
        isPlaytest: isPlaytest,
        htmlUrl: 'https://example.com/$version',
      );

  AppState stateWith({
    required Set<Mod> mods,
    Set<Release> releases = const {},
  }) =>
      AppState(mods: mods, releases: releases);

  Future<void> pumpChips(WidgetTester tester, AppState state, Mod mod) async {
    await tester.pumpWidget(
      StoreProvider<AppState>(
        store: Store<AppState>((state, _) => state, initialState: state),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(child: ModReleaseInfoChips(mod: mod)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows no chips for a dev mod', (tester) async {
    await pumpChips(
      tester,
      stateWith(mods: {mod('{DEV_VERSION}')}),
      mod('{DEV_VERSION}'),
    );

    expect(find.byType(Chip), findsNothing);
  });

  testWidgets('shows a single unsupported chip for an unknown mod id',
      (tester) async {
    final unsupportedMod = mod('1.0.0', id: 'unknown-mod');

    await pumpChips(
      tester,
      stateWith(mods: {unsupportedMod}),
      unsupportedMod,
    );

    expect(find.byType(Chip), findsOneWidget);
    expect(find.text('UPDATES NOT SUPPORTED'), findsOneWidget);
  });

  testWidgets('shows only the current release chip when up to date',
      (tester) async {
    final stableMod = mod('1.0.0');

    await pumpChips(
      tester,
      stateWith(mods: {stableMod}, releases: {rel(10, '1.0.0')}),
      stableMod,
    );

    expect(find.text('CURRENT RELEASE'), findsOneWidget);
    expect(find.text('CURRENT PLAYTEST'), findsNothing);
  });

  testWidgets('shows only the current playtest chip when running the '
      'latest playtest that is newer than the latest release',
      (tester) async {
    final playtestMod = mod('1.1.0');

    await pumpChips(
      tester,
      stateWith(
        mods: {playtestMod},
        releases: {rel(10, '1.0.0'), rel(20, '1.1.0', isPlaytest: true)},
      ),
      playtestMod,
    );

    expect(find.text('CURRENT PLAYTEST'), findsOneWidget);
    expect(find.text('CURRENT RELEASE'), findsNothing);
  });

  testWidgets('shows no chips when the installed version is outdated',
      (tester) async {
    final outdatedMod = mod('0.9.0');

    await pumpChips(
      tester,
      stateWith(
        mods: {outdatedMod},
        releases: {rel(10, '1.0.0'), rel(20, '1.1.0', isPlaytest: true)},
      ),
      outdatedMod,
    );

    expect(find.byType(Chip), findsNothing);
  });

  testWidgets('keeps the current release chip when a newer playtest is '
      'available upstream', (tester) async {
    final stableMod = mod('1.0.0');

    await pumpChips(
      tester,
      stateWith(
        mods: {stableMod},
        releases: {rel(20, '1.1.0', isPlaytest: true), rel(10, '1.0.0')},
      ),
      stableMod,
    );

    expect(find.text('CURRENT RELEASE'), findsOneWidget);
    expect(find.text('CURRENT PLAYTEST'), findsNothing);
  });
}
