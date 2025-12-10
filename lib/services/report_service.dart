import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/common.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportService {
  static const _supportEmail = 'visionwill3322@gmail.com';
  static String _appInfo = '';
  static String _deviceInfo = '';

  /// 앱·디바이스 정보 초기화 및 보고서 전송을 한번에 수행
  static Future<void> report() async {
    await init();
    await sendReport();
  }

  /// 앱 버전 및 디바이스 정보 로드
  static Future<void> init() async {
    await Future.wait([_loadAppInfo(), _loadDeviceInfo()]);
  }

  static Future<void> _loadAppInfo() async {
    final pkg = await PackageInfo.fromPlatform();
    final isPlus = pkg.packageName.contains('plus');

    _appInfo = """
${isPlus ? '${AppString.appName.tr}+' : AppString.appName.tr}
App Version: ${pkg.version} (build ${pkg.buildNumber})""";
  }

  static Future<void> _loadDeviceInfo() async {
    final plugin = DeviceInfoPlugin();

    if (GetPlatform.isAndroid) {
      final info = await plugin.androidInfo;
      _deviceInfo =
          'Device: ${info.manufacturer} ${info.model}\n'
          'OS: Android ${info.version.release}';
    } else {
      final info = await plugin.iosInfo;
      final machine = info.utsname.machine;

      _deviceInfo =
          'Device: ${info.name} ${info.model} ($machine\n'
          'OS: iOS ${info.systemVersion}';
    }
  }

  static Future<void> sendReport() async {
    final email = Email(
      body: _composeBody(),
      subject: AppString.emailSubject.tr,
      recipients: [_supportEmail],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } on PlatformException catch (e) {
      if (e.code == 'not_available') _handleEmailNotAvailable();
    }
  }

  static Future<void> _handleEmailNotAvailable() async {
    final fallback = await _launchFallback();
    if (!fallback) {
      final copy = await CommonDialog.errorNoEnrolledEmail();
      if (copy) copyWord(_supportEmail);
    }
  }

  static Future<bool> _launchFallback() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {
        'subject': AppString.emailSubject.tr,
        'body': _composeBody(),
      },
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    }
    return false;
  }

  static String _composeBody() => '''${AppString.reportMsgContect.tr}

---
$_appInfo
$_deviceInfo
''';
}
