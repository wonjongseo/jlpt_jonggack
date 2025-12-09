import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart' as FB;
import 'package:jlpt_jonggack/features/setting/services/setting_repository.dart';

class FSController extends GetxController {
  static FSController get to => Get.find<FSController>();
  late final FB.Debouncer debouncer;
  final debouncerDuration = Duration(milliseconds: 500);

  /// font size = 14
  final _baseFS = 14.0.obs; //Base Font Size
  /// font size = 14
  double get baseFS => _baseFS.value;

  @override
  void onInit() {
    super.onInit();
    debouncer = FB.Debouncer();

    getBaseFontSize();
  }

  void getBaseFontSize() {
    _baseFS.value = SettingRepository.getDouble(AppConstant.fontSizeKey) ?? 14;
  }

  void updateBaseFontSize({bool isIncrease = true, double? fontSize}) {
    double newValue = isIncrease ? _baseFS.value + 1 : _baseFS.value - 1;

    if (fontSize != null) {
      newValue = fontSize;
    }

    if (newValue > 20 || newValue < 12) return;
    _baseFS.value = newValue;

    debouncer.debounce(
      duration: debouncerDuration,
      onDebounce: () {
        SettingRepository.setDouble(AppConstant.fontSizeKey, newValue);
      },
    );
  }
}
