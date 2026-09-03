import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/store/store.dart';
import 'package:openra_launcher/widgets/app.widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();
  final store = await createStore();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(OpenRALauncher(store: store, savedThemeMode: savedThemeMode));
}
