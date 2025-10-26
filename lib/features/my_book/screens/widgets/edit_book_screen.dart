import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/common/widget/custom_text_feild.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/model/book.dart';

class EditBookScreen extends StatefulWidget {
  static String name = '/edit-book';

  const EditBookScreen({super.key});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late TextEditingController titleTController;
  late TextEditingController descriptionTController;

  bool isEditMode = false;

  @override
  void initState() {
    titleTController = TextEditingController();
    descriptionTController = TextEditingController();

    isHasBook();
    super.initState();
  }

  void isHasBook() {
    Book? book = Get.arguments as Book?;
    if (book == null) return;
    titleTController.text = book.title;
    descriptionTController.text = book.description;
    setState(() => isEditMode = true);
  }

  void tapBottomBtn() {
    String title = titleTController.text.trim();

    if (title.isEmpty) {
      SnackBarHelper.showErrorSnackBar(AppString.plzEnterBookName.tr);
      return;
    } else if (title.length >= 20) {
      SnackBarHelper.showErrorSnackBar(AppString.plzEnterMore20Char.tr);
      return;
    }

    String description = descriptionTController.text.trim();

    if (description.length >= 50) {
      SnackBarHelper.showErrorSnackBar(AppString.plzEnterMess20Char.tr);
      return;
    }
    Get.back(
      result: {
        'title': title,
        'description': description,
        'isEditMode': isEditMode,
        'isDelete': false,
      },
    );
  }

  void deleteBtn() {
    Get.back(result: {'isDelete': true});
  }

  @override
  void dispose() {
    titleTController.dispose();
    descriptionTController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEditMode ? AppString.changeBook.tr : AppString.createBook.tr,
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (isEditMode)
                    Expanded(
                      child: BottomBtn(
                        label: AppString.delete.tr,
                        backgroundColor: Colors.redAccent,
                        onTap: deleteBtn,
                      ),
                    ),
                  Expanded(
                    child: BottomBtn(
                      label:
                          isEditMode
                              ? AppString.change.tr
                              : AppString.create.tr,
                      onTap: tapBottomBtn,
                    ),
                  ),
                ],
              ),
              GlobalBannerAdmob(),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextFormField(
                      hintText: AppString.bookName.tr,
                      controller: titleTController,
                    ),
                    SizedBox(height: 12),
                    CustomTextFormField(
                      hintText: AppString.bookDesc.tr,
                      controller: descriptionTController,
                      maxLines: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
