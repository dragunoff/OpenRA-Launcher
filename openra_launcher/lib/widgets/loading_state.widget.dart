import 'package:flutter/material.dart';
import 'package:openra_launcher/constants/constants.dart';
import 'package:openra_launcher/widgets/loading_indicator.widget.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({Key? key, this.text = 'Loading...'}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Container(
        margin: const EdgeInsets.only(bottom: Constants.spacing2x),
        child: Text(text),
      ),
    ];

    children.add(const LoadingIndicator());

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    ));
  }
}
