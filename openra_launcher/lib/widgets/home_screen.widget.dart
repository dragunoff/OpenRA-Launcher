import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:openra_launcher/models/app_release.dart';
import 'package:openra_launcher/store/app_state.dart';
import 'package:openra_launcher/widgets/app_bar_popup_menu.widget.dart';
import 'package:openra_launcher/widgets/app_update_dialog.widget.dart';
import 'package:openra_launcher/widgets/label_with_icon.widget.dart';
import 'package:openra_launcher/widgets/mods_home.widget.dart';
import 'package:openra_launcher/widgets/updates_home.widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.title, required this.onInit})
      : super(key: key);

  final String title;
  final void Function() onInit;

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  final List<Tab> mainTabs = [
    const Tab(child: LabelWithIcon(icon: Icons.list, text: 'Mods')),
    const Tab(child: LabelWithIcon(icon: Icons.update, text: 'Updates')),
  ];
}

class _HomeScreenState extends State<HomeScreen> {
  bool shoudlOpenUpdateDialog = true;

  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppRelease? appRelease =
        StoreProvider.of<AppState>(context).state.appRelease;
    bool checkFoUpdates =
        StoreProvider.of<AppState>(context).state.autoCheckAppUpdates;

    Future.delayed(Duration.zero, () {
      if (shoudlOpenUpdateDialog && checkFoUpdates && appRelease != null) {
        showDialog(
            context: context, builder: (context) => const AppUpdateDialog());
      }
      setState(() {
        shoudlOpenUpdateDialog = false;
      });
    });

    return DefaultTabController(
        length: widget.mainTabs.length,
        child: Scaffold(
          appBar: AppBar(
              title: Text(widget.title),
              actions: const [AppBarPopupMenu()],
              bottom: TabBar(tabs: widget.mainTabs)),
          body: const TabBarView(
            children: [
              ModsHome(),
              UpdatesHome(),
            ],
          ),
        ));
  }
}
