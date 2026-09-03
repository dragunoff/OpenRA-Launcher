import 'package:material_ui/material_ui.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: ShapeDecoration(
        shape: const CircleBorder(),
        color: Theme.of(context).highlightColor,
      ),
    );
  }
}
