import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';

class CardLayout extends StatelessWidget {
  const CardLayout({
    super.key,
    required this.header,
    this.topRight,
    this.bottom,
  });

  final Widget header;
  final Widget? topRight;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing2x),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: header),
                ?topRight,
              ],
            ),
            if (bottom != null) ...[
              const SizedBox(height: AppConstants.spacing),
              bottom!,
            ],
          ],
        ),
      ),
    );
  }
}
