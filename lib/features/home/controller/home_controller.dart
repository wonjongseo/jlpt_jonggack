import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/appReviewRequest.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/features/home/controller/book_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/notification/notification.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';

StreamController<String> streamController = StreamController.broadcast();

class HomeController extends GetxController {
  late BookController bookController;
  late PageController pageController;

  final _bookTypeIndex = 0.obs;
  int get bookTypeIndex => _bookTypeIndex.value;

  @override
  void onInit() {
    _bookTypeIndex.value = LocalReposotiry.getProgress(
      AppConstant.bookTypeIdxKey,
    );
    bookController = Get.put(
      BookController(BookType.values[_bookTypeIndex.value]),
    );
    pageController = PageController(initialPage: _bookTypeIndex.value);
    super.onInit();
  }

  @override
  void onReady() {
    _init();

    super.onReady();
  }

  void _init() async {
    await _setNotification();
    await _appReviewRequest();
  }

  Future<void> _setNotification() async {
    await FlutterLocalNotification.init();
    await Future.delayed(const Duration(seconds: 3));
    final isGranted =
        await FlutterLocalNotification.requestNotificationPermission();

    if (isGranted) {
      SettingController.to.setIsAlertGranted(value: true);
      await FlutterLocalNotification.showNotification();
    }
  }

  Future<void> _appReviewRequest() async {
    AppReviewRequest.checkReviewRequest();
  }

  void animateToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void onPageChanged(int index) {
    _bookTypeIndex.value = index;
    bookController.bookType = BookType.values[_bookTypeIndex.value];
    LocalReposotiry.setProgress(
      AppConstant.bookTypeIdxKey,
      _bookTypeIndex.value,
    );
  }

  @override
  void onClose() {
    streamController.close();
    pageController.dispose();
    super.onClose();
  }
}
