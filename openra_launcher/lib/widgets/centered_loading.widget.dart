import 'package:material_ui/material_ui.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, this.text = 'Loading...'});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
        child:
            Column(children: [const CircularProgressIndicator(), Text(text)]));
  }
}
