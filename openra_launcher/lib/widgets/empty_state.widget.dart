import 'package:flutter/material.dart';
import 'package:openra_launcher/constants/constants.dart';

class EmptyState extends StatelessWidget {
  const EmptyState(
      {Key? key,
      required this.text,
      this.buttonText = '',
      this.buttonIcon,
      this.buttonOnPressed})
      : super(key: key);

  final String text;
  final String buttonText;
  final IconData? buttonIcon;
  final void Function()? buttonOnPressed;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Container(
        margin: const EdgeInsets.only(bottom: Constants.spacing2x),
        child: Text(text),
      ),
    ];

    if (buttonText.isNotEmpty) {
      var button = buttonIcon != null
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
