import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/utils/show_bottom_sheet.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/widgets/date_picker_bottom_sheet.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class MyWordScreenBottomSheet extends GetView<NewMyWordController> {
  const MyWordScreenBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: SettingController.to.blackOrWhite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 10),
            height: 5,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          ListTile(
            // title: Text('날자 선택'),
            onTap: () {
              showCustomBottomSheet(
                context: context,
                child: const DatePickerBottomSheet(),
              );
            },
            leading: Obx(
              () => Icon(
                Icons.calendar_month,
                color:
                    controller.selectedDay.value != null || controller.isRanged
                        ? SettingController.to.mainColor
                        : null,
              ),
            ),
            trailing: Obx(
              () => Text(
                controller.dateString,
                style: TextStyle(
                  fontSize: 13,
                  color: SettingController.to.realBlackOrWhite,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Divider(height: 1, color: Colors.grey.shade300),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppString.filter.tr),
                Obx(
                  () => Row(
                    children: List.generate(MyWordType.values.length, (i) {
                      final type = MyWordType.values[i];
                      final isSelected = controller.selectedType == type;
                      return InkWell(
                        onTap: () {
                          controller.changeType(type);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? SettingController.to.mainColor
                                    : null,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                          ).copyWith(left: 16),
                          child: Text(
                            type.label,
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : SettingController.to.realBlackOrWhite,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 300),
        ],
      ),
    );
  }
}
