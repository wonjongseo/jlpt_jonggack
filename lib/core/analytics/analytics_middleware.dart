import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'analytics_service.dart';

/// GetX route middleware: 화면 이동 시 GA screen_view 로깅
class AnalyticsMiddleware extends GetMiddleware {
  AnalyticsMiddleware({
    this.screenName,
    this.ignoreRoutes = const {},
    this.priorityValue = 0,
  });

  /// 특정 라우트에 강제로 찍고 싶은 screenName(옵션)
  final String? screenName;

  /// 로깅 제외할 라우트명들(예: /splash, /debug 등)
  final Set<String> ignoreRoutes;

  /// GetMiddleware priority
  final int priorityValue;

  String? _routeName;

  @override
  int? get priority => priorityValue;

  @override
  GetPage? onPageCalled(GetPage? page) {
    // 이 미들웨어는 보통 각 GetPage에 붙기 때문에 page.name으로 라우트명 확보 가능
    _routeName = page?.name;
    return page;
  }

  @override
  Widget onPageBuilt(Widget page) {
    final route = screenName ?? _routeName ?? Get.currentRoute;
    if (route.isNotEmpty && !ignoreRoutes.contains(route)) {
      // GetMiddleware는 sync라 await 불가 → 비동기 로깅은 백그라운드로 던짐
      unawaited(
        AnalyticsService.I.logScreenView(
          screenName: route,
          // 필요하면 class도 넣고 싶을 때:
          // screenClass: page.runtimeType.toString(),
        ),
      );
    }
    return page;
  }
}
