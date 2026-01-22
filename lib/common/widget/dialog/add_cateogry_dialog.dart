import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/common/widget/custom_text_feild.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/my_voca/components/custom_button.dart';

class AddCatagoryDialog extends StatelessWidget {
  const AddCatagoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final teCtl = TextEditingController();
    return AlertDialog.adaptive(
      content: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            CustomTextFormField(
              autofocus: true,
              label: AppString.categoryName.tr,
              controller: teCtl,
            ),
            SizedBox(height: 24),
            CustomButton(
              borderRadius: 12,
              onTap: () {
                final value = teCtl.text;
                if (value.length >= 15) {
                  Get.back();
                  SnackBarHelper.showErrorSnackBar(
                    AppString.plzEnterCategoryNameLess15Char.tr,
                  );
                  return;
                }
                Get.back(result: teCtl.text);
              },
              label: AppString.save.tr,
            ),
          ],
        ),
      ),
    );
  }
}
