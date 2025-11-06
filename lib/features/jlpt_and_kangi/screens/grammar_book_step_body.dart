import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/calendar_step/grammar_calendar_step_screen.dart';
import 'package:jlpt_jonggack/features/grammar_step/services/grammar_controller.dart';
import 'package:jlpt_jonggack/features/jlpt_home/screens/jlpt_home_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/features/setting/services/setting_repository.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class GrammarBookStepBody extends StatefulWidget {
  final String level;

  const GrammarBookStepBody({super.key, required this.level});
  @override
  State<GrammarBookStepBody> createState() => _GrammarBookStepBodyState();
}

class _GrammarBookStepBodyState extends State<GrammarBookStepBody> {
  late GrammarController grammarController;
  int progrssingIndex = 0;
  UserController userController = Get.find<UserController>();
  CarouselSliderController carouselController = CarouselSliderController();

  @override
  void initState() {
    grammarController = Get.put(GrammarController(level: widget.level));

    progrssingIndex = LocalReposotiry.getProgress(
      '${CategoryEnum.grammars.name}-${widget.level}',
    );

    super.initState();
  }

  void goTo(int index, String chapter) {
    grammarController.setStep(index);
    Get.toNamed(
      GrammarCalendarStepScreen.name,
      arguments: {'chapter': chapter, 'categoryEnum': CategoryEnum.grammars},
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (controller) {
        return CarouselSlider(
          carouselController: carouselController,
          options: CarouselOptions(
            enableInfiniteScroll: false,
            disableCenter: true,
            initialPage: progrssingIndex,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              progrssingIndex = index;
            },
            scrollDirection: Axis.horizontal,
          ),
          items: List.generate(grammarController.grammers.length, (index) {
            bool isAllAccessable =
                !(widget.level == '1' && index > 2) ||
                controller.user!.isPremieum ||
                controller.user!.isTrik;

            bool isFinished =
                grammarController.grammers[index].isFinished ?? false;

            return InkWell(
              onLongPress: () {
                if (isAllAccessable) {
                  return;
                }
                userController.changeUserAuth();
              },
              onTap: () {
                if (!isAllAccessable) {
                  CommonDialog.appealDownLoadThePaidVersion();
                  return;
                }
                setState(() {
                  progrssingIndex = index;
                  carouselController.animateToPage(progrssingIndex);
                });
                LocalReposotiry.setProgress(
                  '${CategoryEnum.grammars.name}-${widget.level}',
                  progrssingIndex,
                );
                goTo(index, '${AppString.chapter.tr}${index + 1}');
              },
              child: Card(
                color: !isAllAccessable ? Colors.grey.shade400 : Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                CategoryEnum.grammars.id,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isEn ? 20 : 23,
                                  color:
                                      isAllAccessable
                                          ? AppColors.mainBordColor
                                          : Colors.grey,
                                ),
                              ),
                              Text(
                                'Chapter ${(index + 1)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color:
                                      isAllAccessable
                                          ? AppColors.mainBordColor
                                          : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (!isAllAccessable)
                          const Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.lock, size: 100),
                          ),
                        if (isFinished)
                          const Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.done, size: 100),
                          ),
                        if (progrssingIndex == index)
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Card(
                              shape: const CircleBorder(),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.lightGreen,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
