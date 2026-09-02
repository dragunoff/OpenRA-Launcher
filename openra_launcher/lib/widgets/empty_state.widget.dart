import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';

class EmptyState extends StatelessWidget {
  const EmptyState(
      {super.key,
      required this.text,
      this.buttonText = '',
      this.buttonIcon,
      this.buttonOnPressed});

  final String text;
  final String buttonText;
  final IconData? buttonIcon;
  final void Function()? buttonOnPressed;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacing2x),
        child: Text(text),
      ),
    ];

    if (buttonText.isNotEmpty) {
      final button = buttonIcon != null
          ? OutlinedButton.icon(
              label: Text(buttonText),
              icon: Icon(buttonIcon),
              onPressed: buttonOnPressed,
            )
          : OutlinedButton(onPressed: buttonOnPressed, child: Text(buttonText));

      children.add(button);
    }

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    ));
  }
}
