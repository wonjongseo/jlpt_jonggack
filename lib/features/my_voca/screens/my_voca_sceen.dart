import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/my_voca/components/custom_calendar.dart';
import 'package:jlpt_jonggack/features/my_voca/components/my_page_navigator.dart';
import 'package:jlpt_jonggack/features/my_voca/screens/my_voca_study_screen.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';
import 'package:jlpt_jonggack/features/my_voca/services/my_voca_controller.dart';

import '../../../common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/admob/controller/ad_controller.dart';

const MY_VOCA_PATH = '/my_voca';

// ignore: must_be_immutable
class MyVocaPage extends StatefulWidget {
  late AdController? adController;
  late bool isManualSavedWord;

  MyVocaPage({super.key}) {
    isManualSavedWord =
        Get.arguments[MY_VOCA_TYPE] == MyVocaEnum.MANUAL_SAVED_WORD;

    adController = Get.find<AdController>();
  }

  @override
  State<MyVocaPage> createState() => _MyVocaPageState();
}

class _MyVocaPageState extends State<MyVocaPage> {
  UserController userController = Get.find<UserController>();

  String selectedFilter1 = MyVocaPageFilter1.ALL_VOCA.id;
  String selectedFilter2 = MyVocaPageFilter2.JAPANESE.id;
  late MyVocaController myVocaController;

  String appBarTitle = '';
  @override
  void initState() {
    super.initState();

    myVocaController = Get.put(
      MyVocaController(isManualSavedWordPage: widget.isManualSavedWord),
    );
    appBarTitle =
        myVocaController.isManualSavedWordPage ? '나만의 단어장 2' : '나만의 단어장 1';
  }

  @override
  Widget build(BuildContext context) {
    final kFirstDay = DateTime(
      myVocaController.kToday.year,
      myVocaController.kToday.month - 3,
      myVocaController.kToday.day,
    );
    final kLastDay = DateTime(
      myVocaController.kToday.year,
      myVocaController.kToday.month + 3,
      myVocaController.kToday.day,
    );

    return GetBuilder<MyVocaController>(
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: const GlobalBannerAdmob(),
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            centerTitle: true,
            title: Text(
              appBarTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Responsive.height10 * 1.8,
              ),
            ),
          ),
          body: ValueListenableBuilder<List<MyWord>>(
            valueListenable: controller.selectedEvents,
            builder: (context, value, _) {
              int knownWordCount = 0;
              int unKnownWordCount = 0;

              for (int i = 0; i < value.length; i++) {
                if (value[i].isKnown) {
                  knownWordCount++;
                } else {
                  unKnownWordCount++;
                }
              }
              return Center(
                child: Column(
                  children: [
                    CustomCalendar(kFirstDay: kFirstDay, kLastDay: kLastDay),
                    SizedBox(height: Responsive.height20),
                    MyPageNavigator(
                      knownWordCount: knownWordCount,
                      unKnownWordCount: unKnownWordCount,
                      value: value,
                    ),
                    SizedBox(height: Responsive.height10 / 2),
                    hearder(knownWordCount, unKnownWordCount, controller),
                    Divider(height: Responsive.height20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            controller.selectedWord.length,
                            (index) {
                              if (controller.isOnlyKnown) {
                                if (controller.selectedWord[index].isKnown ==
                                    false) {
                                  return const SizedBox();
                                }
                              } else if (controller.isOnlyUnKnown) {
                                if (controller.selectedWord[index].isKnown ==
                                    true) {
                                  return const SizedBox();
                                }
                              }
                              return myWordCard(controller, index);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Padding myWordCard(MyVocaController controller, int index) {
    String japanese = controller.selectedWord[index].getWord();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.width10,
        vertical: Responsive.height10 * 0.7,
      ),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            if (controller.selectedWord[index].isKnown)
              SlidableAction(
                onPressed: (context) {
                  controller.updateWord(
                    controller.selectedWord[index].word,
                    false,
                  );
                },
                backgroundColor: Colors.grey,
                label: '미암기로 변경',
                icon: Icons.remove,
              )
            else
              SlidableAction(
                onPressed: (context) {
                  controller.updateWord(
                    controller.selectedWord[index].word,
                    true,
                  );
                },
                backgroundColor: AppColors.mainColor,
                label: '암기로 변경',
                icon: Icons.check,
                foregroundColor: Colors.white,
              ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                controller.myWords.remove(controller.selectedWord[index]);
                controller.deleteWord(
                  controller.selectedWord[index],
                  isYokumatiageruWord: !controller.isManualSavedWordPage,
                );
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '단어 삭제',
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                controller.selectedWord[index].isKnown
                    ? AppColors.correctColor
                    : AppColors.lightGrey,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            padding: EdgeInsets.only(left: Responsive.height10 * 0.4),
          ),
          onPressed: () => Get.to(() => MyVocaStduySCreen(index: index)),
          child: Column(
            children: [
              Align(alignment: Alignment.topLeft, child: Text('${index + 1}.')),
              SizedBox(
                height: Responsive.height10 * 4,
                child: Text(
                  controller.isWordFlip
                      ? controller.selectedWord[index].mean
                      : japanese,
                  style: TextStyle(
                    color: AppColors.scaffoldBackground,
                    fontSize: Responsive.width18,
                    fontFamily: AppFonts.japaneseFont,
                  ),
                ),
              ),
              if (controller.selectedWord[index].createdAt != null)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '${controller.selectedWord[index].createdAtString()} 에 저장됨 ',
                    style: TextStyle(
                      fontSize: Responsive.width12,
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Column hearder(
    int knownWordCount,
    int unKnownWordCount,
    MyVocaController controller,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: Responsive.width10,
            left: Responsive.width10,
            bottom: Responsive.height10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.width15,
                    color: AppColors.mainBordColor,
                  ),
                  text: '암기 단어: $knownWordCount개',
                  children: [
                    TextSpan(
                      text: '\n미암기 단어: $unKnownWordCount개',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.width15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    '필터: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.width15,
                    ),
                  ),
                  filterWidget1(controller),
                  const SizedBox(width: 10),
                  filterWidget2(controller),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  DropdownButton<String> filterWidget2(MyVocaController controller) {
    return DropdownButton(
      value: selectedFilter2,
      items: List.generate(
        MyVocaPageFilter2.values.length,
        (index) => DropdownMenuItem(
          value: MyVocaPageFilter2.values[index].id,
          child: Text(
            MyVocaPageFilter2.values[index].id,
            style:
                selectedFilter2 == MyVocaPageFilter2.values[index].id
                    ? TextStyle(
                      fontSize: Responsive.height14,
                      color: Colors.cyan.shade700,
                      fontWeight: FontWeight.bold,
                    )
                    : null,
          ),
        ),
      ),
      onChanged: (v) {
        if (v == '의미') {
          controller.isWordFlip = true;
        } else {
          controller.isWordFlip = false;
        }
        selectedFilter2 = v!;

        setState(() {});
      },
    );
  }

  DropdownButton<String> filterWidget1(MyVocaController controller) {
    return DropdownButton(
      value: selectedFilter1,
      items: List.generate(
        MyVocaPageFilter1.values.length,
        (index) => DropdownMenuItem(
          value: MyVocaPageFilter1.values[index].id,
          child: Text(
            MyVocaPageFilter1.values[index].id,
            style:
                selectedFilter1 == MyVocaPageFilter1.values[index].id
                    ? TextStyle(
                      color: Colors.cyan.shade700,
                      fontSize: Responsive.height14,
                      fontWeight: FontWeight.bold,
                    )
                    : null,
          ),
        ),
      ),
      onChanged: (v) {
        selectedFilter1 = v!;

        if (selectedFilter1 == '모든 단어') {
          //암기단어
          controller.isAll();
        } else if (selectedFilter1 == '암기 단어') {
          controller.isKnow();
        } else if (selectedFilter1 == '미암기 단어') {
          controller.isDontKnow();
        }

        setState(() {});
      },
    );
  }
}
