import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/features/new_grmmar/controllers/new_grammar_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

//OK
class NewGrammarBookStepBody extends GetView<NewGrammarController> {
  const NewGrammarBookStepBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: controller.carouselController,
      options: CarouselOptions(
        enableInfiniteScroll: false,
        disableCenter: true,
        initialPage: controller.curIndex,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) => controller.onPageChanged(index),
        scrollDirection: Axis.horizontal,
      ),
      items: List.generate(controller.grammars.length, (index) {
        bool accessable = controller.isAllAccessable(index);
        bool isFinished = controller.grammars[index].isFinished ?? false;

        return InkWell(
          onLongPress: () => controller.onCardLongPress(index),
          onTap: () => controller.onCardTap(index),
          child: Obx(
            () => Card(
              color: !accessable ? Colors.grey.shade400 : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          CategoryEnum.grammars.id,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isEn ? 20 : 23,
                            color:
                                accessable
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
                                accessable
                                    ? SettingController.to.mainBordColor
                                    : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    if (!accessable) Icon(Icons.lock, size: 100),
                    if (isFinished)
                      const Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.done, size: 100),
                      ),
                    if (controller.curIndex == index)
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

                    //TODO
                    // if (controller.curIndex == index)
                    //   Positioned(
                    //     bottom: 10,
                    //     right: 10,
                    //     child: Card(
                    //       shape: CircleBorder(),
                    //       child: Container(
                    //         height: 30,
                    //         width: 30,
                    //         decoration: BoxDecoration(
                    //           color:
                    //               isFinished
                    //                   ? SettingController.to.mainColor
                    //                   : AppColors.lightGreen,
                    //           borderRadius: BorderRadius.circular(15),
                    //         ),
                    //         child:
                    //             isFinished
                    //                 ? Icon(
                    //                   Icons.done,
                    //                   size: 20,
                    //                   color: Colors.white,
                    //                 )
                    //                 : null,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
