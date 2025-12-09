import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/setting/controller/font_size_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

import '../controller/jlpt_test_controller.dart';

class JlptTestTextFormField extends StatelessWidget {
  const JlptTestTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JlptTestController>(
      builder: (controller) {
        return TextFormField(
          autofocus: true,
          style: TextStyle(
            color: SettingController.to.realBlackOrWhite,
            fontSize: FSController.to.baseFS + .5,
            fontFamily: AppFonts.japaneseFont,
          ),
          onChanged: (value) {
            controller.inputValue = value;
          },
          focusNode: controller.focusNode,
          onFieldSubmitted: (value) {
            controller.onFieldSubmitted(value);
            FocusScope.of(context).unfocus();
          },
          controller: controller.textEditingController,

          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.height8),
              child: Tooltip(
                showDuration: Duration(seconds: 5),
                triggerMode: TooltipTriggerMode.tap,
                message: AppString.openEndedDesc.tr,
                child: Icon(Icons.help, size: 20, color: Colors.grey),
              ),
            ),

            hintText: AppString.plzEnterReading.tr,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: controller.getTheTextEditerBorderRightColor(),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: controller.getTheTextEditerBorderRightColor(),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            hintStyle: TextStyle(fontSize: 12),
            label: Text(
              AppString.reading.tr,
              style: TextStyle(
                color: SettingController.to.nonSelectedColor,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}
