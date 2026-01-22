import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class DeleteCategoryDialog extends StatelessWidget {
  const DeleteCategoryDialog({super.key, required this.categoryName});
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title:
          isEn
              ? Text("Delete $categoryName?")
              : Text('$categoryName를 삭제하시겠습니까?'),
      content:
          isEn
              ? Text(
                "If you delete this category, all words saved in it will also be deleted.\nDo you want to continue?",
              )
              : Text('카테고리를 삭제하면 단어도 함께 삭제됩니다. 그래도 삭제하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(AppString.yes.tr),
        ),
        TextButton(
          onPressed: () => Get.back(result: false),
          style: TextButton.styleFrom(
            foregroundColor: SettingController.to.mainBordColor,
          ),
          child: Text(AppString.no.tr),
        ),
      ],
    );
  }
}
