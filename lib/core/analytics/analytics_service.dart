import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Firebase Analytics(GA4) wrapper service
class AnalyticsService {
  AnalyticsService._internal();

  static final AnalyticsService I = AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// MaterialApp.navigatorObservers에 넣어서 자동 screen tracking(기본) 보조용
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// GA 수집 ON/OFF (예: 개발환경 OFF)
  Future<void> setAnalyticsEnabled(bool enabled) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
    } catch (e, st) {
      _debugLog('setAnalyticsEnabled error: $e', st);
    }
  }

  /// User ID 설정 (PII 금지: 이메일/전화번호 등 넣지 말기)
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e, st) {
      _debugLog('setUserId error: $e', st);
    }
  }

  /// User Property (프로젝트당 제한 있음)
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e, st) {
      _debugLog('setUserProperty error: $e', st);
    }
  }

  /// Screen View 기록 (Flutter는 보통 직접 찍는게 안정적)
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e, st) {
      _debugLog('logScreenView error: $e', st);
    }
  }

  /// 커스텀 이벤트
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: _sanitizeParams(parameters),
      );
    } catch (e, st) {
      _debugLog('logEvent($name) error: $e', st);
    }
  }

  /// 추천 이벤트 예시: 로그인
  Future<void> logLogin({String? method}) async {
    try {
      await _analytics.logLogin(loginMethod: method);
    } catch (e, st) {
      _debugLog('logLogin error: $e', st);
    }
  }

  /// 추천 이벤트 예시: 가입
  Future<void> logSignUp({String? method}) async {
    try {
      await _analytics.logSignUp(signUpMethod: method!);
    } catch (e, st) {
      _debugLog('logSignUp error: $e', st);
    }
  }

  /// 추천 이벤트 예시: 컨텐츠 선택
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  }) async {
    try {
      await _analytics.logSelectContent(
        contentType: contentType,
        itemId: itemId,
      );
    } catch (e, st) {
      _debugLog('logSelectContent error: $e', st);
    }
  }

  // ---- helpers ----

  /// Firebase Analytics 파라미터는 기본 타입만 허용(대부분 String/num/bool)
  Map<String, Object>? _sanitizeParams(Map<String, Object?>? params) {
    if (params == null || params.isEmpty) return null;

    final out = <String, Object>{};
    for (final entry in params.entries) {
      final k = entry.key;
      final v = entry.value;
      if (v == null) continue;

      if (v is String || v is num || v is bool) {
        out[k] = v;
      } else {
        // 복잡한 객체는 문자열로 변환해서 넣기(필요하면 너 규칙대로 변경)
        out[k] = v.toString();
      }
    }
    return out.isEmpty ? null : out;
  }

  void _debugLog(String msg, [StackTrace? st]) {
    if (!kDebugMode) return;
    // ignore: avoid_print
    print('[AnalyticsService] $msg');
    if (st != null) {
      // ignore: avoid_print
      print(st);
    }
  }
}
