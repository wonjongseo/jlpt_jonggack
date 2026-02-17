import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:url_launcher/url_launcher.dart';

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
