import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  static const Color scaffoldBackground = Color(0xFF212A3E);
  static const Color black = Color(0xFF303943);
  static const Color darkGrey = Color(0xFF303943);
  static const Color whiteGrey = Color(0xFFFDFDFD);
  static const Color lightGreen = Color(0xFF78C850);
  static const primaryColor = Color(0xFFFFC107);

  static Color mainBordColor =
      Get.isDarkMode ? Colors.cyan.shade300 : Colors.cyan.shade700;
  static Color mainColor =
      Get.isDarkMode ? Colors.cyan.shade200 : Colors.cyan.shade400;

  static Color darkMainBordColor = Colors.cyan.shade200; // 살짝 밝은 테두리
  static Color darkMainColor = Colors.cyan.shade300; // 본문/메인용
}
