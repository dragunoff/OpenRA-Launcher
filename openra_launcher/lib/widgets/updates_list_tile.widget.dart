import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/models/release.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/store/selectors.dart';
import 'package:openra_launcher/utils/platform_utils.dart';
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

    final List<Widget> trailingChildren = [];
    trailingChildren.add(OutlinedButton.icon(
        icon: const Icon(Icons.download),
        onPressed: () async {
          await PlatformUtils.launchUrlInExternalBrowser(
              widget.release.htmlUrl);
        },
        label: const Text('Go to Download')));

    return InkWell(
        onTap: () async {
          await PlatformUtils.launchUrlInExternalBrowser(
              widget.release.htmlUrl);
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
