import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/model/kangi.dart';
import 'package:jlpt_jonggack/model/word.dart';
import 'package:jlpt_jonggack/repository/grammar_step_repository.dart';
import 'package:jlpt_jonggack/repository/jlpt_step_repository.dart';
import 'package:jlpt_jonggack/repository/kangis_step_repository.dart';

class JSearchController extends GetxController {
  static JSearchController get to => Get.find<JSearchController>();
  late TextEditingController teCnt = TextEditingController();

  final isLoading = false.obs;

  final _words = <Word>[].obs;
  List<Word> get words => _words.value;

  final _kangis = <Kangi>[].obs;
  List<Kangi> get kangis => _kangis.value;

  final _grammars = <Grammar>[].obs;
  List<Grammar> get grammar => _grammars.value;

  Future<void> clearQuery() async {
    _words.clear();
    _kangis.clear();
    _grammars.clear();
    update();
  }

  final _query = ''.obs;
  String get query => _query.value;

  int get totalResultCnt => words.length + kangis.length + _grammars.length;
  Future<void> sendQuery() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      isLoading.value = true;

      _query.value = teCnt.text.trim();
      if (query.isEmpty || query == '') return;

      _words.assignAll(await JlptRepositry.searchWords(_query.value));
      _kangis.assignAll(await KangiRepositroy.searchkangis(_query.value));
      _grammars.assignAll(await GrammarRepositroy.searchGrammars(_query.value));

      if (query.length == 1) {
        String aa = '0123456789';

        if (aa.contains(query)) {
          clearQuery();
        }
      }

      update();
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('$e', isLog: true);
    } finally {
      isLoading.value = false;
    }
  }
}
