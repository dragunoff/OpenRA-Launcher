import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';
import 'package:openra_launcher/widgets/loading_indicator.widget.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.text = 'Loading...'});

  final String text;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacing2x),
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
