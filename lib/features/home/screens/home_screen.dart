import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';

import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/features/home/widgets/home_screen_body.dart';
import 'package:jlpt_jonggack/features/home/widgets/study_category_navigator.dart';
import 'package:jlpt_jonggack/features/home/widgets/welcome_widget.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/features/search/widgets/search_widget.dart';
import 'package:jlpt_jonggack/notification/notification.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';
import 'package:jlpt_jonggack/appReviewRequest.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

StreamController<String> streamController = StreamController.broadcast();

class HomeScreen extends StatefulWidget {
  static String name = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  KindOfStudy kindOfStudy = KindOfStudy.jlpt;
  late PageController pageController;
  int categoryIndex = 0;
  UserController userController = Get.find<UserController>();

  Future setting() async {
    await initNotification();
    await setAppReviewRequest();
  }

  Future<void> setAppReviewRequest() async {
    AppReviewRequest.checkReviewRequest();
  }

  initNotification() async {
    await Future.delayed(const Duration(seconds: 3));
    final isGranted =
        await FlutterLocalNotification.requestNotificationPermission();

    if (isGranted) {
      SettingController.to.setIsAlertGranted(value: true);
      await FlutterLocalNotification.showNotification();
    }
  }

  @override
  void initState() {
    super.initState();
    FlutterLocalNotification.init();
    setting();
    categoryIndex = LocalReposotiry.getProgress(AppConstant.progressKey);
    pageController = PageController(initialPage: categoryIndex);
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
    pageController.dispose();
  }

  void animateToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void onPageChanged(int index) {
    categoryIndex = index;
    LocalReposotiry.setProgress(AppConstant.progressKey, categoryIndex);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == 'HELLOWOLRD') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.to(() => const NotificaionScreen());
            });
          }
        }
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => Get.toNamed(SettingScreen.name),
                      icon: Icon(Icons.settings, size: 22),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const WelcomeWidget(),
                          NewSearchWidget(isHomeScreen: true),
                          const Spacer(flex: 1),
                          StudyCategoryNavigator(
                            onTap: (index) => animateToPage(index),
                            currentPageIndex: categoryIndex,
                          ),
                          const Spacer(flex: 1),
                          Expanded(
                            flex: 25,
                            child: PageView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: pageController,
                              itemCount: 3,
                              onPageChanged: onPageChanged,
                              itemBuilder: (context, index) {
                                switch (index) {
                                  case 0:
                                    return BasicCard();
                                  case 1:
                                    return JLPTCards();
                                  case 2:
                                    return MyCards();
                                }
                              },
                            ),
                          ),
                          const Spacer(flex: 3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [const GlobalBannerAdmob()],
              ),
            ),
          ),
        );
      },
    );
  }
}
