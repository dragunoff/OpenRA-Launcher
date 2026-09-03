import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';

class ButtonRow extends StatelessWidget {
  const ButtonRow({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children.indexed.expand((entry) {
        final (index, child) = entry;
        return [
          if (index > 0) const SizedBox(width: AppConstants.spacing),
          child,
        ];
      }).toList(),
    );
  }
}
