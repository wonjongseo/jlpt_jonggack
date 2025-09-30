import 'package:hive_flutter/adapters.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/logger/logger_service.dart';

class HiveRepository<T extends HiveObject> {
  static HiveRepository get to => Get.find<HiveRepository>();

  final String boxKey;
  late Box<T> _box;

  HiveRepository(this.boxKey);

  /// 1) 박스 초기화: openBox 또는 이미 열려 있으면 box() 호출
  Future<void> initBox() async {
    if (!Hive.isBoxOpen(boxKey)) {
      _box = await Hive.openBox<T>(boxKey);
    } else {
      _box = Hive.box<T>(boxKey);
    }
  }

  /// 2) 단일 엔티티 저장/업데이트 (key: String)
  Future<void> put(String key, T value) async {
    try {
      await _box.put(key, value);
    } catch (e) {
      LogManager.error("$e");
    }
  }

  /// 3) key로 조회
  T? get(String key) {
    return _box.get(key);
  }

  /// 4) key로 삭제
  Future<void> delete(String key) async {
    try {
      await _box.delete(key);
    } catch (e) {
      LogManager.error("$e");
    }
  }

  /// 5) 모든 값 가져오기
  List<T> getAll() {
    return _box.values.toList();
  }

  /// 6) 존재 여부 체크
  bool containsKey(String key) {
    return _box.containsKey(key);
  }

  /// 7) 한 번에 여러 개(batch) 저장하기 (Map<key, T> 형태)
  Future<void> putAll(Map<String, T> items) async {
    await _box.putAll(items);
  }

  /// 8) 박스 닫기
  Future<void> closeBox() async {
    await _box.close();
  }

  Future<void> deleteFromDisk() async {
    print('${_box.runtimeType} is deleteFromDisk');
    await _box.deleteFromDisk();
  }
}
