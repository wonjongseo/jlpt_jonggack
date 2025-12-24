import 'package:hive/hive.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';
import 'package:jlpt_jonggack/common/logger/logger_service.dart';

class SettingRepository {
  // 내부에서 사용할 Box 인스턴스를 캐싱
  static Box<dynamic>? _box;

  // (선택) 앱 시작 시 한 번 호출해서 _box를 할당해줄 수도 있습니다.
  // 하지만 위 예시처럼 main()에서 미리 openBox 해두면 아래처럼 Hive.box()만 써도 됩니다.
  static void init() async {
    _box = Hive.box(AppConstant.settingModelBox);
  }

  // bool 저장 (비동기)
  static Future<void> setBool(
    String key,
    bool value, {
    bool isLog = false,
  }) async {
    if (isLog) {
      LogManager.info('키: $key, 값: $value 저장');
    }
    // box가 null이면 Hive.openBox을 강제로 열어두도록 해도 되지만,
    // 이미 main()에서 열었다면 Hive.box()로 가져오기만 하면 됩니다.
    final box = _box ?? Hive.box(AppConstant.settingModelBox);
    await box.put(key, value);
  }

  // bool 조회 (동기)
  static bool? getBool(String key) {
    final box = _box ?? Hive.box(AppConstant.settingModelBox);
    // 기본값을 null로 두려면 아래처럼 defaultValue 생략 또는 null 지정
    return box.get(key) as bool?;
  }

  // List 저장 (비동기)
  static Future<void> setList(String key, List value) async {
    final box = _box ?? Hive.box(AppConstant.settingModelBox);
    LogManager.info('키: $key, 값: $value 저장');
    await box.put(key, value);
  }

  // List 조회 (동기)
  static List<dynamic> getList(String key) {
    final box = _box ?? Hive.box(AppConstant.settingModelBox);
    // 기본값을 빈 리스트로 두고 싶으면 defaultValue: []
    return box.get(key, defaultValue: <dynamic>[]) as List<dynamic>;
  }

  // String 저장 (비동기)
  static Future<void> setString(String key, String value) async {
    final box = _box ?? Hive.box(AppConstant.settingModelBox);
    LogManager.info('키: $key, 값: $value 저장');
    await box.put(key, value);
  }

  // String 조회 (동기)
  static String? getString(String key) {
    final box = _box ?? Hive.box(AppConstant.settingModelBox);
    return box.get(key) as String?;
  }

  // int 저장 (비동기)
  static Future<void> setInt(
    String key,
    int value, {
    bool isLog = false,
  }) async {
    final box = _box ?? Hive.box(AppConstant.settingModelBox);

    // 유저가 마지막으로 학습한 Category, Subject, Chapter 확인하기 위해

    LogManager.info('키: $key, 값: $value 저장');
    if (isLog) {}
    await box.put(key, value);
  }

  // int 조회 (동기)
  static int? getInt(String key) {
    final box = _box ?? Hive.box(AppConstant.settingModelBox);

    return box.get(key) as int?;
  }

  // int 저장 (비동기)
  static Future<void> setDouble(String key, double value) async {
    final box = _box ?? Hive.box(AppConstant.settingModelBox);

    // 유저가 마지막으로 학습한 Category, Subject, Chapter 확인하기 위해

    LogManager.info('키: $key, 값: $value 저장');
    await box.put(key, value);
  }

  // int 조회 (동기)
  static double? getDouble(String key) {
    final box = _box ?? Hive.box(AppConstant.settingModelBox);

    return box.get(key) as double?;
  }

  static void delete(String key) {
    final box = _box ?? Hive.box(AppConstant.settingModelBox);
    LogManager.info('[삭제] 키: $key');
    box.delete(key);
  }
}
