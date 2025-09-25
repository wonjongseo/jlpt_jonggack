import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/common/widget/custom_snack_bar.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/features/my_voca/components/custom_button.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class ImportExcelFileWidget extends StatelessWidget {
  const ImportExcelFileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    NewMyWordController controller = Get.find<NewMyWordController>();
    UserController userController = Get.find<UserController>();
    return Padding(
      padding: EdgeInsets.all(8),
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Responsive.height16 / 2,
                ),
                child: Text(
                  "아래의 형식에 맞는 엑셀 파일을 불러와주세요.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.width10 * 1.8,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.width16 / 2,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(Responsive.width16 / 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.mainColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("1. 확장자는 .xlsx로 지정해주세요."),
                          SizedBox(height: Responsive.height16 / 4),
                          const Text("2. A(첫번째) 열에는 일본어를 입력해주세요."),
                          SizedBox(height: Responsive.height16 / 4),
                          const Text("3. B(두번째) 열에는 읽는 법를 입력해주세요."),
                          SizedBox(height: Responsive.height16 / 4),
                          const Text("4. C(세번쨰) 열에는 의미를 입력해주세요."),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.height16),
                    excelLikeDataTable(),
                  ],
                ),
              ),
            ],
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: BottomBtn(
              label: "엑셀 파일 불러오기",
              onTap: () async {
                // Get.offAllNamed(HOME_PATH);

                int savedWordNumber = await controller.postExcelData();
                if (savedWordNumber != 0) {
                  Get.back();
                  Get.back();
                  showSnackBar(
                    '$savedWordNumber개의 단어가 저장되었습니다.\n($savedWordNumber 단어가 이미 저장되어 있습니다.)',
                    duration: const Duration(seconds: 4),
                  );
                  userController.updateMyWordSavedCount(
                    true,
                    isYokumatiageruWord: false,
                    count: savedWordNumber,
                  );
                  return;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget excelLikeDataTable() {
    final excelGreen = const Color(0xFF107C10); // Microsoft Excel Green
    final rows = <DataRow>[
      _excelRow(['일본어', 'にほんご', '日本語'], zebra: false),
      _excelRow(['사랑', 'こい', '恋'], zebra: true),
      _excelRow(['공부', 'べんきょう', '勉強'], zebra: false),
    ];

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12), // 외곽선
        borderRadius: BorderRadius.circular(6),
      ),
      child: DataTableTheme(
        data: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(excelGreen),
          headingTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          dataTextStyle: const TextStyle(fontSize: 14),
          dividerThickness: 1, // 가로선 두께
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            showBottomBorder: true,
            headingRowHeight: 44,
            columnSpacing: 40,
            columns: const [
              DataColumn(label: _ExcelHeader('A열')),
              DataColumn(label: _ExcelHeader('B열')),
              DataColumn(label: _ExcelHeader('C열')),
            ],
            rows: rows,
          ),
        ),
      ),
    );
  }
}

class _ExcelHeader extends StatelessWidget {
  final String text;
  const _ExcelHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}

DataRow _excelRow(List<String> cells, {required bool zebra}) {
  return DataRow(
    color: MaterialStateProperty.all(
      zebra ? const Color(0xFFF5F9F5) : Colors.white, // 엑셀 느낌의 줄무늬
    ),
    cells:
        cells
            .map(
              (c) => DataCell(
                Container(
                  alignment: Alignment.center, // 가운데 정렬
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(c),
                ),
              ),
            )
            .toList(),
  );
}
