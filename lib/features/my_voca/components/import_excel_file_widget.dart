import 'package:flutter/material.dart';

import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class ImportExcelFileWidget extends StatelessWidget {
  const ImportExcelFileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "아래의 형식에 맞는 엑셀 파일을 불러와주세요.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Card(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: SettingController.to.mainColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("1. 확장자는 .xlsx로 지정해주세요."),
                        SizedBox(height: 4),
                        const Text("2. A(첫번째) 열에는 일본어를 입력해주세요."),
                        SizedBox(height: 4),
                        const Text("3. B(두번째) 열에는 읽는 법를 입력해주세요."),
                        SizedBox(height: 4),
                        const Text("4. C(세번째) 열에는 의미를 입력해주세요."),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                excelLikeDataTable(),
              ],
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
    color: MaterialStateProperty.all(SettingController.to.blackOrWhite),
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

class ImportExcelFileWidgetEn extends StatelessWidget {
  const ImportExcelFileWidgetEn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Please import an Excel file that matches the format below.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Card(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: SettingController.to.mainColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("1. Use the .xlsx file extension."),
                        SizedBox(height: 4),
                        Text("2. Enter the Japanese word in Column A (first)."),
                        SizedBox(height: 4),
                        Text(
                          "3. Enter the reading (kana) in Column B (second).",
                        ),
                        SizedBox(height: 4),
                        Text("4. Enter the meaning in Column C (third)."),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                excelLikeDataTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget excelLikeDataTable() {
    final excelGreen = const Color(0xFF107C10); // Microsoft Excel Green
    final rows = <DataRow>[
      _excelRow([isEn ? 'Japanese' : '일본어', 'にほんご', '日本語'], zebra: false),
      _excelRow([isEn ? 'Love' : '사랑', 'こい', '恋'], zebra: true),
      _excelRow([isEn ? 'Study' : '공부', 'べんきょう', '勉強'], zebra: false),
    ];

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12), // outline
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
          dividerThickness: 1, // horizontal line thickness
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            showBottomBorder: true,
            headingRowHeight: 44,
            columnSpacing: 40,
            columns: const [
              DataColumn(label: _ExcelHeader('Col A')),
              DataColumn(label: _ExcelHeader('Col B')),
              DataColumn(label: _ExcelHeader('Col C')),
            ],
            rows: rows,
          ),
        ),
      ),
    );
  }
}
