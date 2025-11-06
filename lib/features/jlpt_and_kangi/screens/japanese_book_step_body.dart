import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/features/calendar_step/japanese_calendar_step_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/jlpt/controller/jlpt_step_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/features/setting/services/setting_repository.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class JapaneseBookStepBody extends StatefulWidget {
  final String level;

  const JapaneseBookStepBody({super.key, required this.level});
  @override
  State<JapaneseBookStepBody> createState() => _JapaneseBookStepBodyState();
}

class _JapaneseBookStepBodyState extends State<JapaneseBookStepBody> {
  late JlptStepController jlptWordController;
  int progrssingIndex = 0;
  UserController userController = Get.find<UserController>();
  CarouselSliderController carouselController = CarouselSliderController();

  @override
  void initState() {
    jlptWordController = Get.put(JlptStepController(level: widget.level));

    progrssingIndex = LocalReposotiry.getProgress(
      '${CategoryEnum.japaneses.name}-${widget.level}',
    );

    super.initState();
  }

  void _onTap(bool isAllAccessable, int index) {
    if (!isAllAccessable) {
      CommonDialog.appealDownLoadThePaidVersion();
      return;
    }

    setState(() {
      progrssingIndex = index;
      carouselController.animateToPage(progrssingIndex);
    });

    LocalReposotiry.setProgress(
      '${CategoryEnum.japaneses.name}-${widget.level}',
      progrssingIndex,
    );

    Get.to(() => JapaneseStepScreen(index: index));
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
          items: [
            ...List.generate(jlptWordController.headTitleCount, (index) {
              bool isAllAccessable =
                  !(widget.level == '1' && index > 2) ||
                  controller.user!.isPremieum ||
                  controller.user!.isTrik;

              return InkWell(
                onLongPress: () {
                  if (isAllAccessable) return;
                  userController.changeUserAuth();
                },
                onTap: () => _onTap(isAllAccessable, index),
                child: Card(
                  color: !isAllAccessable ? Colors.grey.shade400 : Colors.white,
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
                                CategoryEnum.japaneses.id,
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
              );
            }),
          ],
        );
      },
    );
  }
}
