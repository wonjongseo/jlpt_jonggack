import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/logger/logger_service.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';

class SnackBarHelper {
  static void showErrorSnackBar(
    String message, {
    String title = "Error",
    bool isLog = false,
    int second = 3,
  }) {
    if (isLog) {
      LogManager.info(message);
    }
    if (Get.isSnackbarOpen) {
      return;
    }
    Get.rawSnackbar(
      message: message,
      backgroundColor: Colors.red,
      borderRadius: 20,
      margin: EdgeInsets.symmetric(horizontal: 20),
      duration: Duration(seconds: second),
      snackPosition: SnackPosition.TOP,
      icon: Icon(Icons.error, color: Colors.white),
    );
  }

  static void showSuccessSnackBar(
    String message, {
    String title = "Success",
    bool isLog = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (isLog) {
      LogManager.info(message);
    }
    if (Get.isSnackbarOpen) return;
    Get.rawSnackbar(
      message: message,
      backgroundColor: Colors.green,
      borderRadius: 20,
      margin: EdgeInsets.symmetric(horizontal: 20),
      duration: duration,
      snackPosition: SnackPosition.TOP,
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void showSelectableSuccessSnackBar(
    String title, {
    String message = "Success",
    bool isLog = false,
  }) {
    if (Get.isSnackbarOpen) return;
    if (isLog) {
      LogManager.info(title);
    }
    Get.snackbar(
      title,
      message,
      titleText: Text(title, style: TextStyle(color: Colors.white)),
      messageText: Text(
        AppString.disableNotiAt.tr,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade100),
      ),
      mainButton: TextButton(
        onPressed: () {
          Get.back();
          Get.toNamed(SettingScreen.name);
        },
        child: Icon(Icons.settings),
      ),
      backgroundColor: Colors.green,
      borderRadius: 20,
      margin: EdgeInsets.symmetric(horizontal: 20),
      duration: Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }

  //   Get.rawSnackbar(
  //     mainButton: IconButton(
  //       onPressed: () {
  //         Get.back();
  //       },
  //       icon: Icon(Icons.settings),
  //     ),
  //     message: message,
  //     backgroundColor: Colors.green,
  //     borderRadius: 20,
  //     margin: EdgeInsets.symmetric(horizontal: 20),
  //     duration: Duration(seconds: 5),
  //     snackPosition: SnackPosition.TOP,
  //     icon: Icon(Icons.check_circle, color: Colors.white),
  //   );
  // }
}
