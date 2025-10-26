import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';

import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/features/setting/screen/widgets/sound_setting_slider.dart';
import 'package:jlpt_jonggack/services/report_service.dart';

class SettingScreen extends GetView<SettingController> {
  static String name = '/setting';
  const SettingScreen({super.key});

  Widget _expansionTile({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        shape: Border(),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        childrenPadding: EdgeInsets.symmetric(horizontal: 8),
        children: children,
      ),
    );
  }

  Widget _innerExpansionTile({
    required String title,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      shape: Border(),
      title: Text(title, style: TextStyle(fontSize: 12)),
      children: children,
    );
  }

  TextStyle get _listTileTitleStyle => TextStyle(fontSize: 12);
  Widget _listTile({
    required String title,
    String? subTitle,
    Widget? trailing,
    Function()? onTap,
  }) {
    return ListTile(
      title: Text(title, style: _listTileTitleStyle),
      subtitle:
          subTitle == null
              ? null
              : Text(subTitle, style: TextStyle(fontSize: 11)),
      trailing: trailing,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(title: Text(AppString.settingScreen.tr)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Obx(
            () => Column(
              children: [
                _expansionTile(
                  title: AppString.appSetting.tr,
                  children: [
                    _listTile(
                      title: AppString.enableOpenEndQustion.tr,
                      trailing: Switch.adaptive(
                        value: controller.isSubjective,
                        onChanged: (v) => controller.toggleSubjective(),
                      ),
                    ),
                    _innerExpansionTile(
                      title: AppString.proun.tr,
                      children: List.generate(SoundOptions.values.length, (i) {
                        final option = SoundOptions.values[i];
                        return SoundSettingSlider(
                          activeColor: option.color,
                          option: option.label,
                          value: controller.tTsValue(option),
                          label: '${option.label}: ${controller.volumn.value}',
                          onChangeEnd: (value) {
                            controller.updateSoundValues(option, value, true);
                          },
                          onChanged: (value) {
                            controller.updateSoundValues(
                              SoundOptions.values[i],
                              value,
                              false,
                            );
                          },
                        );
                      }),
                    ),
                    _innerExpansionTile(
                      title: AppString.quizDuration.tr,
                      children: List.generate(QuizDuration.values.length, (i) {
                        final option = QuizDuration.values[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(option.label, style: _listTileTitleStyle),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed:
                                        () => controller.updateQuizDuration(
                                          option,
                                          true,
                                        ),
                                    icon: Icon(Icons.arrow_drop_up_outlined),
                                  ),
                                  Text(
                                    '${controller.quizValue(option) / 1000} ${AppString.second.tr}',
                                    style: _listTileTitleStyle,
                                  ),
                                  IconButton(
                                    onPressed:
                                        () => controller.updateQuizDuration(
                                          option,
                                          false,
                                        ),
                                    icon: Icon(Icons.arrow_drop_down_outlined),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),

                _expansionTile(
                  title: AppString.systemSetting.tr,
                  children: [
                    _listTile(
                      title: AppString.language.tr,
                      trailing: Obx(() {
                        final String currentLang =
                            (controller.systemLocale ??
                                    Get.locale ??
                                    Get.deviceLocale ??
                                    const Locale('en', 'US'))
                                .languageCode; // 'ko' or 'en'

                        final bool koFirst = currentLang == 'ko';
                        final items =
                            koFirst
                                ? [
                                  DropdownMenuItem<String>(
                                    value: 'ko',
                                    child: Text(
                                      '한국어',
                                      style: _listTileTitleStyle,
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'en',
                                    child: Text(
                                      'English',
                                      style: _listTileTitleStyle,
                                    ),
                                  ),
                                ]
                                : [
                                  DropdownMenuItem<String>(
                                    value: 'en',
                                    child: Text(
                                      'English',
                                      style: _listTileTitleStyle,
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'ko',
                                    child: Text(
                                      '한국어',
                                      style: _listTileTitleStyle,
                                    ),
                                  ),
                                ];
                        return DropdownButton2<String>(
                          underline: SizedBox(),
                          value: currentLang,
                          onChanged: (v) {
                            controller.changeSystemLanguage(v);
                          },
                          items: items,
                        );
                      }),
                    ),
                  ],
                ),

                _expansionTile(
                  title: AppString.another.tr,

                  children: [
                    _listTile(
                      title: AppString.fnOrErorreport.tr,
                      subTitle: AppString.tipOffMessage.tr,
                      onTap: () {
                        ReportService.report();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [GlobalBannerAdmob()],
        ),
      ),
    );
  }
}
