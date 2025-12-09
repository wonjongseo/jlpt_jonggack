import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class CustomAppBarTitle extends StatelessWidget {
  const CustomAppBarTitle({
    super.key,
    required this.curIndex,
    required this.totalIndex,
  });

  final int curIndex;
  final int totalIndex;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RichText(
        text: TextSpan(
          style: TextStyle(
            color:
                SettingController.to.isDarkMode
                    ? AppColors.whiteGrey
                    : Colors.black,
            fontSize: appBarTextSize,
          ),
          children: [
            TextSpan(
              text: '$curIndex',
              style: TextStyle(
                color: Colors.cyan.shade500,
                fontSize: Responsive.height10 * 2.5,
              ),
            ),
            const TextSpan(text: ' / '),
            TextSpan(text: '$totalIndex'),
          ],
        ),
      ),
    );
  }
}
