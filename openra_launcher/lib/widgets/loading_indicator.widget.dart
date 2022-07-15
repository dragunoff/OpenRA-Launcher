import 'package:flutter/material.dart';
import 'package:openra_launcher/constants/constants.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(Constants.spacing),
        child: const CircularProgressIndicator());
  }
}
