import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/search/widgets/search_widget.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/jlpt_step.dart';
import 'package:jlpt_jonggack/repository/jlpt_step_repository.dart';
import 'package:jlpt_jonggack/repository/kangis_step_repository.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';

class NewJlptScreen extends GetView<NewJlptController> {
  static String name = '/newJlptScreen';
  const NewJlptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('JLPT N${controller.levelIndex + 1}')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              NewSearchWidget(isHomeScreen: true),
              SizedBox(height: 16),
              _navigator(),
              SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  controller.categoryIdx;
                  return PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: CategoryEnum.values.length,
                    controller: controller.pageController,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Center(
                          child: Text(
                            CategoryEnum.values[controller.categoryIdx].id,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navigator() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(CategoryEnum.values.length, (i) {
          final type = CategoryEnum.values[i];

          final isSelected = i == controller.categoryIdx;
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => controller.onChangePage(i),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: isEn ? 2 : 0),
              decoration: BoxDecoration(
                border:
                    isSelected
                        ? Border(
                          bottom: BorderSide(
                            width: isEn ? 2 : 3,
                            color: Colors.cyan.shade600,
                          ),
                        )
                        : null,
              ),
              child: Text(
                isKo ? '${type.id} ${AppString.vocabulary.tr}' : type.id,
                style:
                    isSelected
                        ? TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan.shade600,
                          fontSize: 17,
                        )
                        : TextStyle(color: Colors.grey.shade600, fontSize: 15),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class NewJlptController extends GetxController {
  static NewJlptController get to => Get.find<NewJlptController>();
  final int levelIndex;

  final _categoryIdx = 0.obs; // 카테고리
  int get categoryIdx => _categoryIdx.value;
  late PageController pageController;

  final japaneseChapterCnt = 0.obs;
  final kangiChapterCnt = 0.obs;
  final grammarChapterCnt = 0.obs;

  NewJlptController(this.levelIndex);

  JlptJapaneseController? japaneseCtl;
  JlptKangiController? kangiCtl;
  JlptGrammarController? grammarCtl;

  void fetchChapterCtn() {
    japaneseChapterCnt.value = JlptStepRepositroy().getCountByJlptHeadTitle(
      '$levelIndex',
    );
    kangiChapterCnt.value = KangiStepRepositroy().getCountByHangul(
      '$levelIndex',
    );
    // grammarChapterCnt.value = GrammarRepositroy().getCountByJlptHeadTitle(
    //   '$levelIndex',
    // );
  }

  @override
  void onInit() {
    _categoryIdx.value = LocalReposotiry.getProgress('${levelIndex + 1}');
    pageController = PageController(initialPage: _categoryIdx.value);
    super.onInit();
  }

  void onChangePage(int index) {
    _categoryIdx.value = index;
    pageController.animateToPage(
      _categoryIdx.value,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    LocalReposotiry.setProgress('${levelIndex + 1}', _categoryIdx.value);

    final type = CategoryEnum.values[_categoryIdx.value];

    switch (type) {
      case CategoryEnum.japaneses:
        japaneseCtl = Get.put(JlptJapaneseController());
        deleteKangiConroller();
        deleteGrammarConroller();
        break;
      case CategoryEnum.kangis:
        kangiCtl = Get.put(JlptKangiController());
        deleteJapaneseConroller();
        deleteGrammarConroller();
        break;
      case CategoryEnum.grammars:
        grammarCtl = Get.put(JlptGrammarController());
        deleteJapaneseConroller();
        deleteKangiConroller();
        break;
    }
  }

  void deleteJapaneseConroller() {
    if (Get.isRegistered<JlptJapaneseController>()) {
      Get.delete<JlptJapaneseController>();
      japaneseCtl = null;
    }
  }

  void deleteKangiConroller() {
    if (Get.isRegistered<JlptKangiController>()) {
      Get.delete<JlptKangiController>();
      kangiCtl = null;
    }
  }

  void deleteGrammarConroller() {
    if (Get.isRegistered<JlptGrammarController>()) {
      Get.delete<JlptGrammarController>();
      grammarCtl = null;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

abstract class JlptCategoryController extends GetxController {
  late PageController pageController;
  late int chapterIdx;
}

class JlptJapaneseController extends JlptCategoryController {
  final repository = JlptStepRepositroy();

  final jlptSteps = <List<JlptStep>>[].obs;

  void getJlptSteps() {}

  @override
  void onInit() {
    final level = NewJlptController.to.levelIndex;

    final chatperCnt = repository.getCountByJlptHeadTitle(level.toString());

    for (var i = 0; i < chatperCnt; i++) {
      jlptSteps.add(
        repository.getJlptStepByHeadTitle(level.toString(), '챕터${i + 1}'),
      );
    }

    chapterIdx = LocalReposotiry.getProgress(
      '${CategoryEnum.japaneses.name}-$level',
    );
    super.onInit();
  }
}

class JlptKangiController extends GetxController {}

class JlptGrammarController extends GetxController {}
