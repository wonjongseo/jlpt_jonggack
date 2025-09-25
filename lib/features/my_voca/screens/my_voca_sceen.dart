import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/calendar_step/widgets/c_toggle_btn.dart';
import 'package:jlpt_jonggack/features/my_voca/components/custom_calendar.dart';
import 'package:jlpt_jonggack/features/my_voca/components/my_page_navigator.dart';
import 'package:jlpt_jonggack/features/my_voca/screens/my_voca_study_screen.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';
import 'package:jlpt_jonggack/features/my_voca/services/my_voca_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../common/admob/banner_ad/global_banner_admob.dart';

// const MY_VOCA_PATH = '/my_voca';

class MyVocaPage extends StatefulWidget {
  late bool isManualSavedWord;

  MyVocaPage({super.key}) {
    isManualSavedWord =
        Get.arguments[MY_VOCA_TYPE] == MyVocaEnum.MANUAL_SAVED_WORD;
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
      2018,
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
        return ValueListenableBuilder<List<MyWord>>(
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
            return Scaffold(
              bottomNavigationBar: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [const GlobalBannerAdmob()],
                ),
              ),
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
                actions: [_bottomSheet(value.isNotEmpty)],
              ),
              body: Center(
                child: Column(
                  children: [
                    // if (!controller.isSeeAllData)
                    CustomCalendar(kFirstDay: kFirstDay, kLastDay: kLastDay),
                    const SizedBox(height: 20),
                    MyPageNavigator(
                      knownWordCount: knownWordCount,
                      unKnownWordCount: unKnownWordCount,
                      value: value,
                    ),
                    const SizedBox(height: 5),
                    hearder(knownWordCount, unKnownWordCount, controller),
                    const Divider(height: 20),
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
              ),
            );
          },
        );
      },
    );
  }

  Padding myWordCard(MyVocaController controller, int index) {
    String word = controller.selectedWord[index].word;
    if (controller.isWordFlip) {
      word = controller.selectedWord[index].mean;
      if (controller.selectedWord[index].mean.contains('\n')) {
        List<String> temp = controller.selectedWord[index].mean.split('\n');
        int ranNum = Random().nextInt(temp.length);
        if (temp[ranNum].contains('. ')) {
          word = temp[ranNum].split('. ')[1];
        } else {
          word = temp[ranNum];
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
        child: InkWell(
          onTap: () => Get.to(() => MyVocaStduySCreen(index: index)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              color:
                  controller.selectedWord[index].isKnown
                      ? AppColors.correctColor
                      : AppColors.lightGrey,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('${index + 1}.'),
                ),
                SizedBox(
                  height: 35,
                  child: Text(
                    word,
                    style: TextStyle(
                      color: AppColors.scaffoldBackground,
                      fontSize: controller.isWordFlip ? 15 : 18,
                      fontFamily: AppFonts.japaneseFont,
                    ),
                  ),
                ),
                if (controller.selectedWord[index].createdAt != null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${controller.selectedWord[index].createdAtString()} 에 저장됨 ',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
  IconButton _bottomSheet(bool isNotEmpty) {
    Size size = MediaQuery.of(context).size;
    return IconButton(
      onPressed: () {
        Get.bottomSheet(
          Container(
            width: double.infinity,
            color: Colors.white,
            child: GetBuilder<MyVocaController>(
              builder: (controller) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 5,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ToggleSwitch(
                      initialLabelIndex: controller.tS2selectedIndex,
                      totalSwitches: 2,
                      activeFgColor: Colors.white,
                      activeBgColor: [AppColors.mainColor],
                      inactiveBgColor: Colors.grey.shade200,
                      minWidth: size.width / 3 - 20,
                      labels: const ['일본어', '의미'],
                      onToggle: (index) {
                        controller.onClickToggleSwitch2(index);
                      },
                    ),
                    const SizedBox(height: 16),
                    ToggleSwitch(
                      initialLabelIndex: controller.tS1selectedIndex,
                      totalSwitches: 3,
                      activeFgColor: Colors.white,
                      activeBgColor: [AppColors.mainColor],
                      inactiveBgColor: Colors.grey.shade200,
                      minWidth: size.width / 3 - 20,
                      labels: const ['모든 단어', '암기 단어', '미암기 단어'],
                      onToggle: (index) {
                        controller.onClickToggleSwitch1(index);
                      },
                    ),

                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '선택된 단어 전체 삭제',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // CToggleBtn(
                    //   label: '의미 가리기',
                    //   toggle: controller.toggleSeeMean,
                    //   value: controller.isSeeMean,
                    // ),
                    // const SizedBox(height: 10),
                    // CToggleBtn(
                    //   label: '읽는 법 가리기',
                    //   toggle: controller.toggleSeeYomikata,
                    //   value: controller.isSeeYomikata,
                    // ),
                    // CheckRowBtn(
                    //   label: '단어 전체 저장',
                    //   value: controller.isAllSave(),
                    //   onChanged: (v) => controller.toggleAllSave(),
                    // ),
                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        );
      },
      icon: const Icon(Icons.menu),
    );
  }

  //

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

        setState(() {});
      },
    );
  }
}
