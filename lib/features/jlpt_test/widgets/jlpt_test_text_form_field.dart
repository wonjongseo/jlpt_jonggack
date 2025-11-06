import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';

import '../../../config/colors.dart';
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
            color: controller.getTheTextEditerBorderRightColor(isBorder: false),
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
                color: AppColors.scaffoldBackground.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}
