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

  static Future<void> appealDownLoadThePaidVersion() async {
    Get.dialog(AppealUpgrade());
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

class AppealUpdateJgPlus extends StatelessWidget {
  const AppealUpdateJgPlus({super.key, required this.label});

  final String label;
  @override
  Widget build(BuildContext context) {
    final plusFeatureStyle = TextStyle(
      fontSize: 12,
      color: SettingController.to.realBlackOrWhite.withValues(alpha: .9),
    );

    return AlertDialog.adaptive(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1),
          Text(
            AppString.pleaseUseJgPluse.tr,
            style: TextStyle(
              fontSize: 15,
              color: SettingController.to.mainBordColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),

          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),

            decoration: BoxDecoration(
              color: SettingController.to.blackOrWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '+ ${AppString.unlimitedJlptWords.tr}',
                  style: plusFeatureStyle,
                ),
                SizedBox(height: 4),
                Text('+ ${AppString.removeAds.tr}', style: plusFeatureStyle),
                SizedBox(height: 4),
                Text(
                  '+ ${AppString.unlimitedBooks.tr}',
                  style: plusFeatureStyle,
                ),
                SizedBox(height: 4),
                Text(
                  '+ ${AppString.unlimitedCategoris.tr}',
                  style: plusFeatureStyle,
                ),
              ],
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
              height: 40,
              decoration: BoxDecoration(
                color: SettingController.to.mainColor,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                isEn ? 'Download JLPT Jg Plus→' : 'JLPT종각 Plus 다운로드→',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
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
                        color: SettingController.to.mainBordColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              )
              //JLPT N1을 더 학습하기 위해서는\nJLPT 종각앱 Plus를 이용해주세요
              : RichText(
                text: TextSpan(
                  text: 'JLPT N1을 더 학습하기 위해서는',
                  children: [
                    TextSpan(
                      text: '\nJLPT 종각앱 Plus',
                      style: TextStyle(
                        color: SettingController.to.mainColor,
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
