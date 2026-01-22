import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/common/widget/book_category_selector.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/common/widget/custom_text_feild.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/widgets/manual_add_word_widget.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/book.dart';
import 'package:jlpt_jonggack/model/book_catgory.dart';

class EditBookScreen extends StatefulWidget {
  static String name = '/edit-book';

  const EditBookScreen({super.key});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late TextEditingController titleTController;
  late TextEditingController descriptionTController;
  final List<BookCategory> bookCategories = [];
  BookCategory? selectedCat;
  bool isEditMode = false;
  Book? book;
  @override
  void initState() {
    titleTController = TextEditingController();
    descriptionTController = TextEditingController();

    book = Get.arguments as Book?;
    if (book == null) {
      selectedCat = BookCategory.unspecified;
      bookCategories.add(selectedCat!);
    } else {
      _setUpBook();
    }
    super.initState();
  }

  void _setUpBook() {
    titleTController.text = book!.title;
    descriptionTController.text = book!.description;
    bookCategories.assignAll(book!.categories ?? []);
    selectedCat = book!.selectedCategory;
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

    if (description.length >= 100) {
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
    selectedCat ??= BookCategory.unspecified;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEditMode ? AppString.changeBook.tr : AppString.createBook.tr,
          ),
        ),
        body: _body(),
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }

  SafeArea _body() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Card(
          color: SettingController.to.blackOrWhite,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                BookCategorySelector(
                  label: AppString.category.tr,
                  cats: bookCategories,
                  selectedCat: selectedCat,
                  onAdd: (value) {
                    setState(() {
                      final cat = BookCategory(value);
                      bookCategories.add(cat);
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      final cat = bookCategories.firstWhereOrNull(
                        (cat) => cat.id == value,
                      );
                      selectedCat = cat;
                    });
                  },
                  onDelete: (value) {
                    Get.back();
                    setState(() {
                      bookCategories.removeWhere((cat) => cat.id == value);
                    });
                  },
                ),
                SizedBox(height: 20),

                CustomTextFormField(
                  label: AppString.bookName.tr,
                  controller: titleTController,
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  label: AppString.bookDesc.tr,
                  controller: descriptionTController,
                  maxLines: 10,
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SafeArea _bottomNavigationBar() {
    return SafeArea(
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
                  label: isEditMode ? AppString.change.tr : AppString.create.tr,
                  onTap: tapBottomBtn,
                ),
              ),
            ],
          ),
          GlobalBannerAdmob(),
        ],
      ),
    );
  }
}
