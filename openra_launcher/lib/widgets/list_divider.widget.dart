import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';

class ListDivider extends StatelessWidget {
  const ListDivider(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacing, horizontal: AppConstants.spacing2x),
        child: Text(text, style: TextStyle(fontSize: 18.0)));
  }
}
