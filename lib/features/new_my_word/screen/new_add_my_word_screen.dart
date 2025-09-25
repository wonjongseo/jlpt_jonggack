import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/features/my_voca/components/import_excel_file_widget.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/widgets/manual_add_word_widget.dart';

TextStyle accentTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: AppColors.mainColor,
  fontSize: 16,
);

class NewAddMyWordScreen extends StatelessWidget {
  static String name = '/new-add-my-word';
  const NewAddMyWordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              isScrollable: false, // 많으면 true로 스와이프형
              labelColor: AppColors.mainColor,
              unselectedLabelColor: Colors.black,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              dividerColor: Colors.transparent,
              indicatorColor: AppColors.mainColor, // 기본 밑줄 색
              tabs: [Tab(text: '직접 입력'), Tab(text: '엑셀 불러오기')],
            ),
            // title: Text('단어 저장'),
          ),
          bottomNavigationBar: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [GlobalBannerAdmob()],
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
