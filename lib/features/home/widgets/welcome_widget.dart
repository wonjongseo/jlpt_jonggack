import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    int curHour = now.hour;
    String gretting = '';

    if (curHour > 1 && curHour < 13) {
      gretting = 'おはようございます';
    } else if (curHour >= 13 && curHour < 19) {
      gretting = 'こんにちは';
    } else {
      gretting = 'こんばんは';
    }

    return GetBuilder<UserController>(
      builder: (userController) {
        return Column(
          children: [
            Text(
              gretting,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppString.appName.tr,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: SettingController.to.mainBordColor,
                  ),
                ),
                if (userController.user!.isPremieum)
                  Text(
                    '+',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.redAccent,
                    ),
                  ),
                Text(
                  'へようこそ',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
