import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:jlpt_jonggack/common/widget/animated_circular_progressIndicator.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class StudyCategoryAndProgress extends StatelessWidget {
  final String caregory;
  final int curCnt;
  final int totalCnt;
  const StudyCategoryAndProgress({
    super.key,
    required this.caregory,
    required this.curCnt,
    required this.totalCnt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2).copyWith(bottom: 15),
      child: isKo ? _ko() : _en(),
    );
  }

  Column _en() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              caregory,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Responsive.height15,
              ),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: curCnt / 100),
              duration: const Duration(milliseconds: 1500),
              builder: (context, value, child) {
                return RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: SettingController.to.realBlackOrWhite,
                      fontSize: Responsive.width10 * 1.2,
                      letterSpacing: 2,
                    ),
                    children: [
                      TextSpan(
                        text: '${(value * 100).ceil()}',
                        style: TextStyle(
                          color: SettingController.to.mainBordColor,
                        ),
                      ),
                      const TextSpan(text: '/'),
                      TextSpan(text: '$totalCnt'),
                    ],
                  ),
                );
              },
            ),
          ],
        ),

        SizedBox(height: 5),
        AnimatedLeanerProgressIndicator(
          currentProgressCount: curCnt,
          totalProgressCount: totalCnt,
        ),
      ],
    );
  }

  Row _ko() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          caregory,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: curCnt / 100),
                duration: const Duration(milliseconds: 1500),
                builder: (context, value, child) {
                  return Obx(
                    () => RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: SettingController.to.realBlackOrWhite,
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                        children: [
                          TextSpan(
                            text: '${(value * 100).ceil()}',
                            style: TextStyle(
                              color: SettingController.to.mainBordColor,
                            ),
                          ),
                          const TextSpan(text: '/'),
                          TextSpan(text: '$totalCnt'),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 4),
              AnimatedLeanerProgressIndicator(
                currentProgressCount: curCnt,
                totalProgressCount: totalCnt,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
