import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/core/platform/open_external_url.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';
import 'package:openra_launcher/injection.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/installed_mods/selectors.dart';
import 'package:openra_launcher/widgets/mod_icon.widget.dart';

class UpdatesListTile extends StatefulWidget {
  const UpdatesListTile({
    Key? key,
    required this.release,
    this.isFavorite = false,
  }) : super(key: key);

  final Release release;
  final bool isFavorite;

  @override
  State<UpdatesListTile> createState() => _UpdatesListTileState();
}

class _UpdatesListTileState extends State<UpdatesListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final mod = selectModById(
        StoreProvider.of<AppState>(context).state, widget.release.modId);
    final leading = ModIcon(mod: mod);
    final openExternalUrl = getIt<OpenExternalUrl>();

    final List<Widget> trailingChildren = [];
    trailingChildren.add(OutlinedButton.icon(
        icon: const Icon(Icons.download),
        onPressed: () async {
          await openExternalUrl(widget.release.htmlUrl).run();
        },
        label: const Text('Go to Download')));

    return InkWell(
        onTap: () async {
          await openExternalUrl(widget.release.htmlUrl).run();
        },
        onHover: (hovering) {
          setState(() {
            _isHovered = hovering;
          });
        },
        onFocusChange: (focused) {
          setState(() {
            _isHovered = focused;
          });
        },
        child: ListTile(
          mouseCursor: SystemMouseCursors.click,
          leading: leading,
          title: Text(mod.title),
          subtitle: Text(widget.release.version),
          trailing: _isHovered
              ? FittedBox(child: Row(children: trailingChildren))
              : null,
        ));
  }
}
