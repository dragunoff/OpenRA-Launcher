import 'package:flutter/material.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/features/updates/widgets/updates_card.widget.dart';

class UpdatesList extends StatelessWidget {
  const UpdatesList({Key? key, required this.releases}) : super(key: key);

  final Set<Release> releases;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: releases.length,
        itemBuilder: (BuildContext context, int index) {
          final Release mod = releases.elementAt(index);
          return UpdatesCard(release: mod);
        });
  }
}
