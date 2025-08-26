import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/common.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportService {
  static const _supportEmail = 'visionwill3322@gmail.com';
  static String _appInfo = '';
  static String _deviceInfo = '';

  /// 앱·디바이스 정보 초기화 및 보고서 전송을 한번에 수행
  static Future<void> report(BuildContext context) async {
    await init();
    await sendReport(context);
  }

  /// 앱 버전 및 디바이스 정보 로드
  static Future<void> init() async {
    await Future.wait([_loadAppInfo(), _loadDeviceInfo()]);
  }

  static Future<void> _loadAppInfo() async {
    final pkg = await PackageInfo.fromPlatform();
    _appInfo = 'App Version: ${pkg.version} (build ${pkg.buildNumber})';
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
      _deviceInfo =
          'Device: ${info.name} ${info.model}\n'
          'OS: iOS ${info.systemVersion}';
    }
  }

  /// 이메일 앱을 통해 보고서 전송
  static Future<void> sendReport(BuildContext context) async {
    final email = Email(
      body: _composeBody(),
      subject: _subject,
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
      queryParameters: {'subject': _subject, 'body': _composeBody()},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    }
    return false;
  }

  static String get _subject => '[JLPT 종각] 버그・오류 제보';
  static String _composeBody() => '''$reportMsgContectKr

---
$_appInfo
$_deviceInfo
''';
}

String reportMsgContectKr = """
💡 **희망 기능 제안 / 버그·오류 제보**

───────────────────────

✨ **[희망 기능 제안]**
- 원하는 기능이나 개선 아이디어를 상세히 알려주세요!

───────────────────────

🐞 **[버그・오류 제보]**
1️⃣ **발생 화면**  
   예) 캘린더 화면, 비용 입력 화면 등  
2️⃣ **발생 내용**  
   예) 일정 추가 시 앱이 강제 종료됩니다.  
3️⃣ **재현 방법**  
   1. 캘린더 화면 진입  
   2. “일정 추가” 버튼 클릭  
   3. 오류 확인  

📎 **첨부 가능 항목**  
- 스크린샷 또는 동영상 (버그 파악에 큰 도움이 됩니다!)

───────────────────────

🙏 **소중한 제보 감사합니다!**  
빠른 시일 내에 검토하고 개선하도록 하겠습니다.
""";
