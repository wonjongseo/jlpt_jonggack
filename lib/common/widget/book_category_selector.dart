import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jlpt_jonggack/common/widget/dialog/add_cateogry_dialog.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/book_catgory.dart';

class BookCategorySelector extends StatelessWidget {
  const BookCategorySelector({
    super.key,
    required this.label,
    required this.cats,
    this.selectedCat,
    required this.onChanged,
    required this.onAdd,
    required this.onDelete,
    this.wordCntPerCategory,
  });

  final String label;
  final List<BookCategory> cats;
  final BookCategory? selectedCat;
  final Function(String?) onChanged;
  final Function(String) onAdd;
  final Function(String) onDelete;
  final Map<BookCategory, int>? wordCntPerCategory;
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: SettingController.to.blackOrWhite,
        floatingLabelStyle: TextStyle(
          color: SettingController.to.mainBordColor,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      child: DropdownButton2(
        menuItemStyleData: MenuItemStyleData(),
        underline: SizedBox(),
        isExpanded: true,

        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: SettingController.to.blackOrWhite,
          ),
        ),

        onChanged: (value) {
          onChanged(value);
        },
        value: selectedCat?.id,
        items: [
          ...List.generate(cats.length, (i) {
            final cat = cats[i];
            bool canDelete =
                cat != BookCategory.unspecified && cat != selectedCat;

            return DropdownMenuItem(
              value: cat.id,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    wordCntPerCategory == null
                        ? cat.name
                        : '${cat.name} (${wordCntPerCategory![cat]})',
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (canDelete)
                    IconButton(
                      onPressed: () => onDelete(cat.id),
                      icon: Icon(
                        Icons.delete,
                        color: SettingController.to.realBlackOrWhite,
                        size: 20,
                      ),
                    ),
                ],
              ),
            );
          }),
          DropdownMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppString.add.tr,
                  style: TextStyle(
                    color: SettingController.to.realBlackOrWhite,
                    fontSize: 15.5,
                  ),
                ),
                Icon(
                  Icons.add,
                  color: SettingController.to.realBlackOrWhite,
                  size: 20,
                ),
              ],
            ),
            onTap: () {
              Get.closeCurrentSnackbar();
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                final value = await Get.dialog(AddCatagoryDialog());
                if (value == null) return;
                onAdd(value);
              });
            },
          ),
        ],
      ),
    );
  }
}
