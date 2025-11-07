import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import 'package:jlpt_jonggack/model/my_word.dart';

class ExcelService {
  static String _cellToTrimmed(List<Data?> row, int index) {
    if (index < 0 || index >= row.length) return '';
    final data = row[index];
    final value = data?.value;
    if (value == null) return '';
    return value.toString().replaceAll(RegExp(r'\s+'), '');
  }

  static Future<List<MyWord>?> postExcelData() async {
    FilePickerResult? picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
      allowMultiple: false,
    );

    List<MyWord> mywords = [];

    if (picked == null) {
      return null;
    }

    // 1) bytes 우선, 없으면 경로로 읽기 (플랫폼별 안전 처리)
    Uint8List? bytes = picked.files.single.bytes;
    if (bytes == null) {
      final path = picked.files.single.path;
      if (path == null) return mywords;
      bytes = await File(path).readAsBytes();
    }

    final excel = Excel.decodeBytes(bytes);
    try {
      for (final tableKey in excel.tables.keys) {
        final sheet = excel.tables[tableKey];
        if (sheet == null) continue;

        for (final row in sheet.rows) {
          // 각 셀을 안전하게 문자열로 변환 + 공백 제거
          String word = _cellToTrimmed(row, 0);
          String yomikata = _cellToTrimmed(row, 1);
          String mean = _cellToTrimmed(row, 2);

          // 2) 완전 빈행 스킵
          if (word.isEmpty && yomikata.isEmpty && mean.isEmpty) {
            continue;
          }

          // 3) 헤더(첫 row가 '단어/읽기/뜻' 같은 경우) 스킵
          final lower =
              '${word.toLowerCase()}|${yomikata.toLowerCase()}|${mean.toLowerCase()}';
          if (lower.contains('단어') ||
              lower.contains('word') ||
              lower.contains('yomikata') ||
              lower.contains('읽기') ||
              lower.contains('뜻') ||
              lower.contains('mean')) {
            // 헤더로 보이면 스킵
            continue;
          }

          // 4) 최소 필수값 검증 (word/mean 둘 중 하나라도 없으면 스킵)
          if (word.isEmpty || mean.isEmpty) {
            // 필요한 경우 로그만 남기고 계속
            // debugPrint('스킵: 필수값 부족 -> word:"$word", mean:"$mean"');
            continue;
          }

          await Future.delayed(Duration(microseconds: 300));
          final newWord = MyWord(
            word: word,
            mean: mean,
            yomikata: yomikata,
            isManuelSave: true,
          )..createdAt = DateTime.now();
          mywords.add(newWord);
        }
      }
    } catch (e) {
      rethrow;
    }
    print("End");
    return mywords;
  }
}
