import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PlatformUtils {
  // TODO: Extract to a service
  static Future<bool> launchUrlInExternalBrowser(url) async {
    final parsedUrl = Uri.parse(url);

    if (await canLaunchUrl(parsedUrl)) {
      return launchUrl(parsedUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open "$parsedUrl"';
    }
  }

  // TODO: Extract to a service
  static Future<PackageInfo> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}
