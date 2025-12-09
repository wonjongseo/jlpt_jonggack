import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class StudyCategoryNavigator extends StatelessWidget {
  const StudyCategoryNavigator({
    super.key,
    required this.onTap,
    required this.currentPageIndex,
  });

  final Function(int) onTap;
  final int currentPageIndex;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(KindOfStudy.values.length, (index) {
        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ).copyWith(bottom: 4),
            decoration: BoxDecoration(
              border:
                  index == currentPageIndex
                      ? Border(
                        bottom: BorderSide(
                          width: 3,
                          color: Colors.cyan.shade600,
                        ),
                      )
                      : null,
            ),
            child: Center(
              child: Text(
                '${KindOfStudy.values[index].value} ${AppString.vocabulary.tr}',
                style: TextStyle(
                  fontWeight:
                      index == currentPageIndex ? FontWeight.bold : null,
                  color:
                      index == currentPageIndex
                          ? SettingController.to.mainColor
                          : Colors.grey.shade600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
