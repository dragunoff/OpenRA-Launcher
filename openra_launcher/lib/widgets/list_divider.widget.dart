import 'package:flutter/material.dart';
import 'package:openra_launcher/constants/constants.dart';

class ListDivider extends StatelessWidget {
  const ListDivider(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: ThemeData.dark().dividerColor),
        padding: const EdgeInsets.symmetric(
            vertical: Constants.spacing, horizontal: Constants.spacing2x),
        child: Text(text));
  }
}
