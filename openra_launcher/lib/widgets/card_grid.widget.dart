import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';

class CardGrid extends StatelessWidget {
  const CardGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > AppConstants.largeScreenBreakpoint
            ? 3
            : constraints.maxWidth > AppConstants.smallScreenBreakpoint
                ? 2
                : 1;
        return GridView.custom(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: 128,
              mainAxisSpacing: AppConstants.spacing,
              crossAxisSpacing: AppConstants.spacing,
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              itemBuilder,
              childCount: itemCount,
            ));
      },
    );
  }
}
