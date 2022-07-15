import 'package:flutter/material.dart';
import 'package:openra_launcher/constants/constants.dart';

class LabelWithIcon extends StatelessWidget {
  const LabelWithIcon({Key? key, required this.text, required this.icon})
      : super(key: key);

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: const EdgeInsets.only(right: Constants.spacing),
        child: Icon(icon),
      ),
      Text(text)
    ]);
  }
}
