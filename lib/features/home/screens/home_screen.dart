import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';

import 'package:jlpt_jonggack/features/home/controller/home_controller.dart';
import 'package:jlpt_jonggack/features/home/screens/widgets/book_widget.dart';
import 'package:jlpt_jonggack/features/home/widgets/study_category_navigator.dart';
import 'package:jlpt_jonggack/features/home/widgets/welcome_widget.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';
import 'package:jlpt_jonggack/features/search/widgets/search_widget.dart';
import 'package:jlpt_jonggack/notification/notification.dart';

StreamController<String> streamController = StreamController.broadcast();

class HomeScreen extends GetView<HomeController> {
  static String name = '/home';
  const HomeScreen({super.key});

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
            body: _body(),
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

  Widget _body() {
    return SafeArea(
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
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const WelcomeWidget(),
                    NewSearchWidget(isHomeScreen: true),
                    const Spacer(flex: 1),
                    StudyCategoryNavigator(
                      onTap: (index) => controller.animateToPage(index),
                      currentPageIndex: controller.bookTypeIndex,
                    ),
                    SizedBox(height: 4),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 25,
                      child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: controller.pageController,
                        itemCount: 3,
                        onPageChanged: controller.onPageChanged,
                        itemBuilder: (context, index) {
                          return BookWidet(index: index);
                        },
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
