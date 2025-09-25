import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';

import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePickerBottomSheet extends GetView<NewMyWordController> {
  const DatePickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: AspectRatio(
              aspectRatio: 3 / 5,
              child: TableCalendar<MyWord>(
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                locale: Get.locale.toString(),
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                shouldFillViewport: true,
                focusedDay: controller.focusedDay.value,
                rangeSelectionMode: RangeSelectionMode.toggledOn,
                rangeStartDay: controller.rangeStart.value,
                rangeEndDay: controller.rangeEnd.value,
                selectedDayPredicate:
                    (day) => isSameDay(controller.selectedDay.value, day),
                eventLoader: controller.getEventsForDay,
                onDaySelected: (selectedDay, focusedDay) {
                  controller.onDaySelected(selectedDay, focusedDay);
                },
                onRangeSelected: (start, end, focusedDay) {
                  // 미리 컨트롤러에 임시 저장 (실제 필터는 '적용'에서)
                  controller.rangeStart.value = start;
                  controller.rangeEnd.value = end;
                  controller.focusedDay.value = focusedDay;
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: BottomBtn(
                    label: '초기화',
                    backgroundColor: Colors.grey,
                    onTap: () {
                      controller.clearRange(); // 전체 보기
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BottomBtn(
                    label: '적용',
                    onTap: () {
                      controller.applyRange(
                        controller.rangeStart.value,
                        controller.rangeEnd.value,
                      );
                      Get.back();
                    },
                  ),
                ),
                // Expanded(
                //   child: ElevatedButton(
                //     onPressed: () {
                //       controller.applyRange(
                //         controller.rangeStart.value,
                //         controller.rangeEnd.value,
                //       );
                //       Get.back();
                //     },
                //     child: const Text('적용'),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
