import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/my_voca/components/custom_button.dart';
import 'package:jlpt_jonggack/features/setting/controller/font_size_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonDialog {
  static Future<bool> errorNoEnrolledEmail() async {
    return selectionDialog(
      title: Text(
        AppString.failLoadMailApp.tr,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
      ),
      connent: Text(AppString.failLoadMailApp2.tr),
    );
  }

  static Future<bool> selectionDialog({Widget? title, Widget? connent}) async {
    return jonggackDialog(title: title, connent: connent);
  }

  static Future<bool> beforeExitTestPageDialog() async {
    return selectionDialog(
      title: Text(AppString.doExitText.tr),
      connent: Text(AppString.doExitText2.tr),
    );
  }

  static Future<bool> askStartToRemainQuestionsDialog() async {
    return selectionDialog(
      title: Text(
        isEn
            ? 'You still have some questions you got wrong in a previous test.'
            : '과거에 테스트에서 틀린 문제들이 있습니다.',
      ),
      connent: Text(
        isEn
            ? 'Would you like to retake the test using only the questions you answered incorrectly?'
            : '틀린 문제만으로 다시 테스트를 보시겠습니까?',
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  static Future<bool> confirmToSubmitGrammarTest(String remainQuestions) async {
    bool? result =
        isEn
            ? (await jonggackDialog(
              title: Text(
                'There are questions you haven\'t answered.',
                style: TextStyle(fontSize: FSController.to.baseFS + 2),
              ),
              connent: Column(
                children: [
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Remaining questions: '),
                        TextSpan(
                          text: remainQuestions,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                      style: TextStyle(
                        fontSize: FSController.to.baseFS,
                        color: SettingController.to.realBlackOrWhite,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Would you like to submit?',
                    style: TextStyle(
                      fontSize: FSController.to.baseFS,
                      color: SettingController.to.realBlackOrWhite,
                    ),
                  ),
                ],
              ),
            ))
            : (await jonggackDialog(
              title: Text(
                '답을 선택하지 않은 문제가 있습니다.',
                style: TextStyle(fontSize: FSController.to.baseFS + 2),
              ),
              connent: Column(
                children: [
                  SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '남은 문제: '),
                        TextSpan(
                          text: remainQuestions,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                      style: TextStyle(
                        fontSize: FSController.to.baseFS,
                        color: SettingController.to.realBlackOrWhite,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('제출하시겠습니까 ?'),
                ],
              ),
            ));

    return result;
  }

  static Future<bool> jonggackDialog({Widget? title, Widget? connent}) async {
    bool? result = await Get.dialog(
      AlertDialog.adaptive(
        title: title,
        content: connent,
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              AppString.no.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: SettingController.to.mainColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              AppString.yes.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: SettingController.to.mainColor,
              ),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}

class JonggackAvator extends StatelessWidget {
  const JonggackAvator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.width10 * 11,
      height: Responsive.width10 * 11,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/my_avator.jpeg'),
        ),
      ),
    );
  }
}
