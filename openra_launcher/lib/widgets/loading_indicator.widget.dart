import 'package:flutter/material.dart';
import 'package:openra_launcher/constants/app_constants.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(AppConstants.spacing),
        child: const CircularProgressIndicator());
  }
}
