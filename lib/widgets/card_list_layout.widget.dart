import 'package:material_ui/material_ui.dart';

class CardListLayout extends StatelessWidget {
  const CardListLayout({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < itemCount; i++) ...[itemBuilder(context, i)],
      ],
    );
  }
}
