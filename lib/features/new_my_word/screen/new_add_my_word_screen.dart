import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/my_voca/components/import_excel_file_widget.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/edit_word_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/widgets/manual_add_word_widget.dart';
import 'package:jlpt_jonggack/features/setting/controller/font_size_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

TextStyle accentTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: SettingController.to.mainColor,
  fontSize: 16,
);

class NewAddMyWordScreen extends GetView<EditWordController> {
  static String name = '/new-add-my-word';
  const NewAddMyWordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(controller.jgWord == null ? 80 : 35),
            child: AppBar(
              bottom:
                  controller.jgWord == null
                      ? TabBar(
                        onTap: (value) => controller.toggleTab(value),
                        isScrollable: false, // 많으면 true로 스와이프형
                        labelColor: SettingController.to.mainColor,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: FSController.to.baseFS + 3,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: FSController.to.baseFS,
                        ),
                        dividerColor: Colors.transparent,
                        indicatorColor: SettingController.to.mainColor,
                        tabs: [
                          Tab(text: AppString.direclyEnter.tr),
                          Tab(text: AppString.importExcel.tr),
                        ],
                      )
                      : null,
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => BottomBtn(
                    label:
                        controller.tapIndex.value == 0
                            ? AppString.save.tr
                            : AppString.importExcel.tr,
                    onTap: controller.onTapSaveBtn,
                  ),
                ),
                GlobalBannerAdmob(),
              ],
            ),
          ),
          body:
              controller.jgWord == null
                  ? TabBarView(
                    children: [
                      ManualAddWordWidget(),
                      isEn
                          ? ImportExcelFileWidgetEn()
                          : ImportExcelFileWidget(),
                    ],
                  )
                  : ManualAddWordWidget(),
        ),
      ),
    );
  }
}
