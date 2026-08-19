import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';

class CardLayout extends StatelessWidget {
  const CardLayout({
    Key? key,
    required this.header,
    this.topRight,
    this.bottom,
  }) : super(key: key);

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
                if (topRight != null) topRight!,
              ],
            ),
            if (bottom != null) ...[
              const Spacer(),
              bottom!,
            ],
          ],
        ),
      ),
    );
  }
}
