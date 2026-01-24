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

    void onTap() {
      final value = teCtl.text;
      if (value.length >= 15) {
        Get.back();
        SnackBarHelper.showErrorSnackBar(
          AppString.plzEnterCategoryNameLess15Char.tr,
        );
        return;
      }
      Get.back(result: teCtl.text);
    }

    return AlertDialog.adaptive(
      content: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              maxLines: 1,
              autofocus: true,
              label: AppString.categoryName.tr,
              controller: teCtl,
              onEditingComplete: onTap,
            ),
            SizedBox(height: 24),
            CustomButton(
              borderRadius: 12,
              onTap: onTap,
              label: AppString.save.tr,
            ),
          ],
        ),
      ),
    );
  }
}
