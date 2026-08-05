import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/installed_mods/widgets/installed_mods_home.widget.dart';
import 'package:openra_launcher/features/updates/widgets/updates_home.widget.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/widgets/home_screen.widget.dart';
import 'package:redux/redux.dart';

void main() {
  testWidgets('home screen switches content with the navigation rail',
      (tester) async {
    final store = Store<AppState>(
      (state, action) => state,
      initialState: AppState.initial(),
    );

    await tester.pumpWidget(
      StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
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
  });
}
