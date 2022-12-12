import 'package:openra_launcher/domain/entities/release.dart';
import 'package:openra_launcher/store/app_state.dart';

Set<Release> selectReleaseUpdates(AppState state) {
  return state.releases.where((release) => !release.isPlaytest).toSet();
}

Set<Release> selectPlaytestUpdates(AppState state) {
  return state.releases.where((release) => release.isPlaytest).toSet();
}
