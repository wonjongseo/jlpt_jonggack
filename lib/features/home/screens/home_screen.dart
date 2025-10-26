import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/common/controller/tts_controller.dart';
import 'package:jlpt_jonggack/common/widget/custom_snack_bar.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/features/home/services/home_controller.dart';
import 'package:jlpt_jonggack/features/home/widgets/home_screen_body.dart';
import 'package:jlpt_jonggack/features/home/widgets/study_category_navigator.dart';
import 'package:jlpt_jonggack/features/home/widgets/welcome_widget.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/features/search/widgets/search_widget.dart';
import 'package:jlpt_jonggack/notification/notification.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';
import 'package:jlpt_jonggack/appReviewRequest.dart';
import 'package:jlpt_jonggack/services/report_service.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

import '../../../config/colors.dart';
import '../../../config/theme.dart';
import '../../how_to_user/screen/how_to_use_screen.dart';

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
  int selectedCategoryIndex = 0;
  UserController userController = Get.find<UserController>();

  Future setting() async {
    await initNotification();
    await settingFunctions();
    await setAppReviewRequest();
  }

  Future<void> setAppReviewRequest() async {
    AppReviewRequest.checkReviewRequest();
  }

  initNotification() async {
    Future.delayed(
      const Duration(seconds: 3),
      await FlutterLocalNotification.requestNotificationPermission(),
    );
    await FlutterLocalNotification.showNotification();
  }

  Future settingFunctions() async {
    bool isNeedUpdateAllData = LocalReposotiry.getIsNeedUpdateAllData();

    // await CommonDialog.askToDeleteAllDataForUpdateDatas();
    if (isNeedUpdateAllData) {
      bool a = await CommonDialog.askToDeleteAllDataForUpdateDatas();
      if (a) {
        SettingController.to.allDataDelete();
      } else {
        bool secondQuestion = await CommonDialog.askToDeleteAllDataOneMore();

        if (secondQuestion) {
          SettingController.to.allDataDelete();
        }
      }

      LocalReposotiry.putIsNeedUpdateAllData(false);
    }
  }

  @override
  void initState() {
    Get.put(TtsController());
    super.initState();
    FlutterLocalNotification.init();
    setting();
    selectedCategoryIndex = LocalReposotiry.getBasicOrJlptOrMy();
    pageController = PageController(initialPage: selectedCategoryIndex);
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());

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
            key: homeController.scaffoldKey,
            endDrawer: _endDrawer(),
            body: _body(context, homeController),
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

  Drawer _endDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(flex: 2),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.message),
                  title: TextButton(
                    onPressed: () {
                      Get.back();
                      Get.to(() => const HowToUseScreen());
                    },
                    child: Text(
                      '앱 설명 보기',
                      style: TextStyle(
                        fontFamily: AppFonts.gMarket,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.width14,
                        color: AppColors.scaffoldBackground,
                      ),
                    ),
                  ),
                ),

                // ListTile(
                //   leading: const Icon(Icons.alarm),
                //   title: TextButton(
                //     onPressed: () {
                //       Get.back();
                //       Get.toNamed(SETTING_PATH, arguments: {
                //         'isSettingPage': true,
                //       });
                //     },
                //     child: Text(
                //       '학습 알림',
                //       style: TextStyle(
                //         fontFamily: AppFonts.nanumGothic,
                //         fontWeight: FontWeight.bold,
                //         fontSize: Responsive.width14,
                //         color: AppColors.scaffoldBackground,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            const Spacer(flex: 2),
            ListTile(
              leading: const Icon(Icons.mail),
              subtitle: AutoSizeText(
                '제보는 개발자에게 아주 큰 힘이 됩니다 !',
                style: TextStyle(
                  fontFamily: AppFonts.gMarket,
                  fontSize: Responsive.width14,
                  color: AppColors.scaffoldBackground,
                ),
                maxLines: 1,
              ),
              title: TextButton(
                onPressed: () async {
                  await ReportService.report();
                },
                child: Text(
                  '희망 기능 또는 에러 제보',
                  style: TextStyle(
                    fontFamily: AppFonts.gMarket,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.width14,
                    color: AppColors.scaffoldBackground,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  void onPageChanged(int index) {
    selectedCategoryIndex = LocalReposotiry.putBasicOrJlptOrMy(index);
    setState(() {});
  }

  Widget _body(BuildContext context, HomeController homeController) {
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              // onPressed: () => homeController.openDrawer(),
              onPressed: () {
                Get.toNamed(SettingScreen.name);
              },
              icon: Icon(Icons.settings, size: Responsive.height10 * 2.2),
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
                    onTap: (index) {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    currentPageIndex: selectedCategoryIndex,
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
                        return HomeScreenBody(index: selectedCategoryIndex);
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
    );
  }
}
