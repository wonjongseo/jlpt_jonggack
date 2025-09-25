import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/features/my_voca/components/import_excel_file_widget.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/edit_word_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/widgets/manual_add_word_widget.dart';

TextStyle accentTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: AppColors.mainColor,
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
            preferredSize: Size.fromHeight(80),
            child: AppBar(
              bottom: TabBar(
                onTap: (value) => controller.toggleTab(value),
                isScrollable: false, // 많으면 true로 스와이프형
                labelColor: AppColors.mainColor,
                unselectedLabelColor: Colors.black,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                dividerColor: Colors.transparent,
                indicatorColor: AppColors.mainColor, // 기본 밑줄 색
                tabs: [Tab(text: '직접 입력'), Tab(text: '엑셀 불러오기')],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => BottomBtn(
                    label: controller.tapIndex.value == 0 ? '저장' : '엑셀 파일 불러오기',
                    onTap: controller.onTapSaveBtn,
                  ),
                ),
                GlobalBannerAdmob(),
              ],
            ),
          ),
          body: TabBarView(
            children: [ManualAddWordWidget(), ImportExcelFileWidget()],
          ),
        ),
      ),
    );
  }
}
