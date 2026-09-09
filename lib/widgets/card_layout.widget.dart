import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';

class CardLayout extends StatelessWidget {
  const CardLayout({
    super.key,
    required this.header,
    this.topRight,
    this.description,
    this.bottom,
    this.isExpanded = true,
    this.onToggleCollapsed,
  });

  final Widget header;
  final Widget? topRight;
  final Widget? description;
  final Widget? bottom;

  /// Whether the collapsible content below the header is shown. Only relevant
  /// when [onToggleCollapsed] is provided.
  final bool isExpanded;

  /// When provided, the header becomes tappable and a collapse caret is shown.
  final VoidCallback? onToggleCollapsed;

  bool get isCollapsible => onToggleCollapsed != null;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      spacing: AppConstants.spacing2x,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (description != null) ...[description!],
        if (bottom != null) ...[bottom!],
      ],
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing2x),
        child: Column(
          spacing: AppConstants.spacing2x,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggleCollapsed,
              child: Row(
                children: [
                  Expanded(child: header),
                  ?topRight,
                  if (isCollapsible)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppConstants.spacing,
                      ),
                      child: IconButton(
                        onPressed: onToggleCollapsed,
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isCollapsible)
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: isExpanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: content,
                secondChild: const SizedBox.shrink(),
              )
            else
              content,
          ],
        ),
      ),
    );
  }
}
