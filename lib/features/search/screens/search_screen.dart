import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/search/controller/search_controller.dart';
import 'package:jlpt_jonggack/features/search/screens/searched_word_detail_screen.dart';
import 'package:jlpt_jonggack/features/search/widgets/search_widget.dart';

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
                          fontSize: 14,
                          fontFamily: AppFonts.japaneseFont,
                        ),
                      ),
                      Text(
                        '의 검색 결과: ${controller.totalResultCnt}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
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
                            initiallyExpanded: true,
                            shape: Border.all(color: Colors.transparent),
                            title: SearchHeader(label: '일본어'),
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
                            initiallyExpanded: true,
                            shape: Border.all(color: Colors.transparent),
                            title: SearchHeader(label: '한자'),
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
                            initiallyExpanded: true,
                            shape: Border.all(color: Colors.transparent),
                            title: SearchHeader(label: '문법'),
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
        color: AppColors.mainBordColor,
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
      color: Colors.white,

      child: ListTile(
        onTap: onTap,
        isThreeLine: true,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: AppFonts.japaneseFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subTitle),
        ),
      ),
    );
  }
}
