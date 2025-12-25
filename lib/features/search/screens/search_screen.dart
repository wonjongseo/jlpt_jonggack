import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/enums.dart';
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
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              controller.clearQuery();
              controller.teCnt.clear();
              Get.back();
            },
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
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
          if (controller.isLoading.value)
            Center(child: CircularProgressIndicator.adaptive())
          else
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    if (controller.words.isNotEmpty) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionTile(
                            iconColor: SettingController.to.mainColor,
                            initiallyExpanded: true,
                            shape: Border.all(color: Colors.transparent),
                            title: SearchHeader(
                              label: CategoryEnum.japaneses.id,
                            ),
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
                      ),
                    ],
                    if (controller.kangis.isNotEmpty) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionTile(
                            iconColor: SettingController.to.mainColor,
                            initiallyExpanded: true,
                            shape: Border.all(color: Colors.transparent),
                            title: SearchHeader(label: CategoryEnum.kangis.id),
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
                      ),
                    ],
                    if (controller.grammar.isNotEmpty) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionTile(
                            iconColor: SettingController.to.mainColor,
                            initiallyExpanded: true,
                            shape: Border.all(color: Colors.transparent),
                            title: SearchHeader(
                              label: CategoryEnum.grammars.id,
                            ),
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
}

class SearchHeader extends StatelessWidget {
  const SearchHeader({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: SettingController.to.mainBordColor,
      ),
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
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        onTap: onTap,
        isThreeLine: true,
        title: Text(
          title,
          style: TextStyle(
            fontSize: FSController.to.baseFS + 6,
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
