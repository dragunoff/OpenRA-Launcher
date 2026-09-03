import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';

class CardLayout extends StatelessWidget {
  const CardLayout({
    super.key,
    required this.header,
    this.topRight,
    this.description,
    this.bottom,
  });

  final Widget header;
  final Widget? topRight;
  final Widget? description;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing2x),
        child: Column(
          spacing: AppConstants.spacing2x,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: header),
                ?topRight,
              ],
            ),
            if (description != null) ...[description!],
            if (bottom != null) ...[bottom!],
          ],
        ),
      ),
    );
  }
}
