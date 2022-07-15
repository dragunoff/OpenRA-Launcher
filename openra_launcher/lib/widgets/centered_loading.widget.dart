import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key, this.text = 'Loading...'}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            children: [const CircularProgressIndicator(), Text(text)]));
  }
}
