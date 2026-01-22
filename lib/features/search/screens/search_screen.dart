import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/search/controller/search_controller.dart';
import 'package:jlpt_jonggack/features/search/screens/searched_word_detail_screen.dart';
import 'package:jlpt_jonggack/features/search/widgets/search_widget.dart';
import 'package:jlpt_jonggack/features/setting/controller/font_size_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class SearchScreen extends GetView<JSearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AppBar(
            leading: BackButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                controller.clearQuery();
                controller.teCnt.clear();
                Get.back();
              },
            ),
          ),
        ),
        body: Obx(() {
          return _body();
        }),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [const GlobalBannerAdmob()],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                NewSearchWidget(isHomeScreen: false),
                if (!controller.isLoading.value) ...[
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${controller.query} ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: FSController.to.baseFS + 2,
                          fontFamily: AppFonts.japaneseFont,
                          color: SettingController.to.mainBordColor,
                        ),
                      ),
                      Text(
                        '${AppString.seacrhResult.tr}: ${controller.totalResultCnt}',
                        style: TextStyle(
                          fontSize: FSController.to.baseFS,
                          fontFamily: AppFonts.japaneseFont,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 10),
          if (controller.isLoading.value)
            Center(child: CircularProgressIndicator.adaptive())
          else
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    if (controller.words.isNotEmpty) ...[
                      _expansionTile(
                        label: CategoryEnum.japaneses.id,
                        cnt: '${controller.words.length}',
                        children: List.generate(controller.words!.length, (
                          index,
                        ) {
                          String title = controller.words[index].word;
                          String subTitle = controller.words[index].mean;
                          return SearchListTile(
                            title: title,
                            subTitle: subTitle,
                            onTap: () {
                              Get.to(
                                () => SearchedWordDetailScreen(
                                  searchedWords: controller.words,
                                  index: index,
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                    if (controller.kangis.isNotEmpty) ...[
                      SizedBox(height: 10),
                      _expansionTile(
                        label: CategoryEnum.kangis.id,
                        cnt: '${controller.kangis.length}',
                        children: List.generate(controller.kangis.length, (
                          index,
                        ) {
                          String title = controller.kangis[index].japan;
                          String subTitle = controller.kangis[index].korea;
                          return SearchListTile(
                            title: title,
                            subTitle: subTitle,
                            onTap: () {
                              Get.to(
                                () => SearchedKangiDetailScreen(
                                  searchedKangis: controller.kangis,
                                  index: index,
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                    if (controller.grammar.isNotEmpty) ...[
                      SizedBox(height: 10),
                      _expansionTile(
                        label: CategoryEnum.grammars.id,
                        cnt: '${controller.grammar.length}',
                        children: List.generate(controller.grammar.length, (
                          index,
                        ) {
                          String title = controller.grammar[index].grammar;
                          String subTitle = controller.grammar[index].means;
                          return SearchListTile(
                            title: title,
                            subTitle: subTitle,
                            onTap: () {
                              Get.to(
                                () => SearchedGrammarDetailScreen(
                                  searchedGrammar: controller.grammar,
                                  index: index,
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _expansionTile({
    required String label,
    String? cnt,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      dense: true,
      minTileHeight: 20,
      iconColor: SettingController.to.mainColor,
      initiallyExpanded: true,
      shape: Border.all(color: Colors.transparent),
      title: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: SettingController.to.mainBordColor,
            ),
          ),
          if (cnt != null) ...[SizedBox(width: 4), Text('($cnt)')],
        ],
      ),
      children: children,
    );
  }
}

class SearchListTile extends StatelessWidget {
  const SearchListTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
  });

  final String title;
  final String subTitle;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: SettingController.to.blackOrWhite,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        onTap: onTap,
        isThreeLine: true,
        title: Text(
          title,
          style: TextStyle(
            fontSize: FSController.to.baseFS + 5,
            fontFamily: AppFonts.japaneseFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subTitle,
            style: TextStyle(fontSize: FSController.to.baseFS + 1),
          ),
        ),
      ),
    );
  }
}
