import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/custom_snack_bar.dart';
import 'package:jlpt_jonggack/repository/kangis_step_repository.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../model/kangi.dart';

Future<bool> isIpad() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final allInfo = deviceInfo.data;

  if (allInfo['systemName'] != null) {
    if (allInfo['systemName'].contains('iPad')) {
      return true;
    }
  }
  return false;
}

bool isKangi(String word) {
  return word.compareTo('一') >= 0 && word.compareTo('龠') <= 0;
}

bool isKatakana(String word) {
  return word.compareTo('\u30A0') >= 0 && word.compareTo('\u30FF') <= 0;
}

bool isHiragana(String word) {
  return word.compareTo('\u3040') >= 0 && word.compareTo('\u309F') <= 0;
}

bool isJapanses(String word) {
  return isKangi(word) || isKatakana(word) || isHiragana(word);
}

void getBacks(int count) {
  for (int i = 0; i < count; i++) {
    Get.back();
  }
}

List<int> getKangiIndex(
  String japanese,
  KangiStepRepositroy kangiStepRepositroy,
) {
  List<int> result = [];
  for (int i = 0; i < japanese.length; i++) {
    if (isKangi(japanese[i])) {
      Kangi? kangi = kangiStepRepositroy.getKangi(japanese[i]);
      if (kangi != null) {
        result.add(i);
      } else {}
    }
  }
  return result;
}

void copyWord(String text) {
  Clipboard.setData(ClipboardData(text: text));

  if (!Get.isSnackbarOpen) {
    Get.closeAllSnackbars();
    showSnackBar('「$text」가\n 복사(Ctrl + C) 되었습니다.');
  }
}
