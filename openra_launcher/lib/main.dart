import 'package:flutter/material.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/store/store.dart';
import 'package:openra_launcher/widgets/app.widget.dart';

Future<void> main() async {
  configureDependencies();
  final store = await createStore();

  runApp(OpenRALauncher(store: store));
}
