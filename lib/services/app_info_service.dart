import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  static Future<bool> isPlus() async {
    final info = await PackageInfo.fromPlatform();
    return info.packageName.contains('plus');
  }
}
