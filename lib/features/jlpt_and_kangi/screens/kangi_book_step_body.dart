import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/common/widget/dialog/appeal_update_jg_plus.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/calendar_step/kangi_calendar_step_body.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/kangi/controller/kangi_step_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class KangiBookStepBody extends StatefulWidget {
  final String level;

  const KangiBookStepBody({super.key, required this.level});
  @override
  State<KangiBookStepBody> createState() => _KangiBookStepBodyState();
}

class _KangiBookStepBodyState extends State<KangiBookStepBody> {
  late KangiStepController kangiController;
  int progrssingIndex = 0;
  UserController userController = Get.find<UserController>();
  CarouselSliderController carouselController = CarouselSliderController();

  @override
  void initState() {
    kangiController = Get.put(KangiStepController(level: widget.level));

    progrssingIndex = LocalReposotiry.getProgress(
      '${CategoryEnum.kangis.name}-${widget.level}',
    );

    super.initState();
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
          items: List.generate(kangiController.headTitleCount, (index) {
            bool isAllAccessable =
                !(widget.level == '1' && index > 2) ||
                controller.user!.premieum;

            return InkWell(
              onLongPress: () {
                if (isAllAccessable) {
                  return;
                }
                userController.changeUserAuth();
              },
              onTap: () {
                if (!isAllAccessable) {
                  Get.dialog(
                    AppealUpdateJgPlus(label: AppString.upgradePlusForN1.tr),
                  );
                  return;
                }

                setState(() {
                  progrssingIndex = index;
                  carouselController.animateToPage(progrssingIndex);
                });

                LocalReposotiry.setProgress(
                  '${CategoryEnum.kangis.name}-${widget.level}',
                  progrssingIndex,
                );
                Get.to(() => KangiCalendarStepBody(index: index));
              },
              child: Card(
                color: !isAllAccessable ? Colors.grey.shade400 : null,
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
                                CategoryEnum.kangis.id,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isEn ? 20 : 23,
                                  color:
                                      isAllAccessable
                                          ? SettingController.to.mainBordColor
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
                                          ? SettingController.to.mainBordColor
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
              ),
            );
          }),
        );
      },
    );
  }
}
