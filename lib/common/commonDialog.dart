import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/my_voca/components/custom_button.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonDialog {
  static Future<bool> errorNoEnrolledEmail() async {
    return selectionDialog(
      title: Text(
        AppString.failLoadMailApp.tr,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
      ),
      connent: Text(
        AppString.failLoadMailApp2.tr,
        style: TextStyle(color: AppColors.scaffoldBackground),
      ),
    );
  }

  static Future<bool> selectionDialog({Widget? title, Widget? connent}) async {
    return jonggackDialog(
      title: title,
      connent: connent,
      action: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Card(
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () async {
                return Get.back(result: true);
              },
              child: Padding(
                padding: EdgeInsets.all(Responsive.width15),
                child: Text(
                  '네',
                  style: TextStyle(
                    // fontSize: Responsive.height14,
                    fontWeight: FontWeight.w600,
                    color: Colors.cyan.shade600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: Responsive.height10),
          Card(
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () async {
                return Get.back(result: false);
              },
              child: Padding(
                padding: EdgeInsets.all(Responsive.width15),
                child: Text(
                  '아뇨',
                  style: TextStyle(
                    // fontSize: Responsive.height14,
                    fontWeight: FontWeight.w600,
                    color: Colors.cyan.shade600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool> beforeExitTestPageDialog() async {
    return selectionDialog(
      title: Text(AppString.doExitText.tr),
      connent: Text(
        AppString.doExitText2.tr,
        style: TextStyle(color: AppColors.scaffoldBackground),
      ),
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
        style: TextStyle(color: AppColors.scaffoldBackground),
      ),
    );
  }

  static Future<bool> confirmToSubmitGrammarTest(String remainQuestions) async {
    bool result = await Get.dialog(
      AlertDialog(
        shape: Border.all(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                text: '',
                children: [
                  TextSpan(
                    text:
                        isEn
                            ? 'The following questions remain: '
                            : remainQuestions,
                    style: TextStyle(color: Colors.redAccent, fontSize: 18),
                  ),
                  TextSpan(
                    text: isEn ? '$remainQuestions.\n\n' : '번이 남아 있습니다.\n\n',
                  ),
                  TextSpan(
                    text:
                        isEn
                            ? 'Do you want to submit anyway?'
                            : '그래도 제출 하시겠습니까?',
                  ),
                ],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 20),
            const JonggackAvator(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Card(
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () async {
                      return Get.back(result: true);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(Responsive.width15),
                      child: Text(
                        '네',
                        style: TextStyle(
                          // fontSize: Responsive.height14,
                          fontWeight: FontWeight.w600,
                          color: Colors.cyan.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Responsive.height10),
                Card(
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () async {
                      return Get.back(result: false);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(Responsive.width15),
                      child: Text(
                        '아뇨',
                        style: TextStyle(
                          // fontSize: Responsive.height14,
                          fontWeight: FontWeight.w600,
                          color: Colors.cyan.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.height10),
          ],
        ),
      ),
    );

    return result;
  }

  static Future<void> appealDownLoadThePaidVersion() async {
    Get.dialog(AppealUpgrade());
  }

  static Future<bool> jonggackDialog({
    Widget? title,
    Widget? connent,
    Widget? action,
  }) async {
    bool result = await Get.dialog(
      AlertDialog.adaptive(
        title: title,
        content: connent,
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(AppString.no.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(AppString.yes.tr),
          ),
        ],
      ),
    );
    // bool result = await Get.dialog(
    //   barrierDismissible: false,
    //   AlertDialog(
    //     shape: Border.all(),
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         if (title != null) ...[
    //           title,
    //           SizedBox(height: 20),
    //         ],
    //         if (connent != null) ...[
    //           connent,
    //           SizedBox(height: 20),
    //         ],
    //         const Align(alignment: Alignment.center, child: JonggackAvator()),
    //         if (action != null) ...[
    //           SizedBox(height: 20),
    //           action,
    //           SizedBox(height: Responsive.height10),
    //         ],
    //       ],
    //     ),
    //   ),
    // );

    return result;
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

class AppealUpgrade extends StatelessWidget {
  const AppealUpgrade({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isEn
              ? RichText(
                text: TextSpan(
                  text: 'To continue learning JLPT N1,\nplease use ',
                  children: [
                    TextSpan(
                      text: 'JLPT Jonggack Plus',
                      style: TextStyle(
                        color: AppColors.mainBordColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              )
              : RichText(
                text: TextSpan(
                  text: 'JLPT N1을 더 학습하기 위해서는',
                  children: [
                    TextSpan(
                      text: '\nJLPT 종각앱 Plus',
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: '를 이용해주세요'),
                  ],
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),

          SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              if (GetPlatform.isIOS) {
                launchUrl(Uri.parse('https://apps.apple.com/app/id6450434849'));
              } else if (GetPlatform.isAndroid) {
                launchUrl(
                  Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.wonjongseo.jlpt_jonggack_plus',
                  ),
                );
              } else {
                launchUrl(Uri.parse('https://apps.apple.com/app/id6450434849'));
              }
            },

            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                isEn ? 'Download JLPT Jg Plus→' : 'JLPT종각 Plus 다운로드→',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
