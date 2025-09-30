import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
import 'package:jlpt_jonggack/model/example.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/services/excel_service.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class EditWordController extends GetxController {
  final externalDictType = ExternalDictType.naver.obs;

  void toggleExternalDictType(ExternalDictType? type) {
    if (type == null) return;
    externalDictType.value = type;
  }

  final tapIndex = 0.obs;
  void toggleTab(int index) {
    if (index == 1) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    tapIndex.value = index;
  }

  void onTapSaveBtn() {
    switch (tapIndex.value) {
      case 0:
        addWord();
        break;
      case 1:
        addWordsByExcel();
        break;
    }
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  void addWord() {
    if (wordFormKey.currentState!.validate()) {
      String japanese = japaneseController.text;
      String yomikata = yomikataController.text;
      String mean = meanController.text;

      if (!appendExample()) {
        return;
      }

      final myword = MyWord(
        word: japanese,
        mean: mean,
        yomikata: yomikata,
        examples: _examples,
        isManuelSave: true,
      );

      MyBookController.to.addMyWord(myword);
      NewMyWordController.to.loadMyWords();
      SnackBarHelper.showSuccessSnackBar('${myword.getWord()}가 저장되었습니다.');

      japaneseController.clear();
      yomikataController.clear();
      meanController.clear();

      japaneseFocusNode.requestFocus();

      _examples.clear();
      exampleWordController.clear();
      exampleMeanController.clear();
    }
  }

  void addWordsByExcel() async {
    try {
      _isLoading.value = true;
      List<MyWord> convertMyWord = await ExcelService.postExcelData();

      int savedWordCnt = await MyBookController.to.bulkHandleMyWords(
        convertMyWord,
      );
      if (convertMyWord.isNotEmpty && savedWordCnt == 0) {
        SnackBarHelper.showErrorSnackBar('이미 저장된 단어(들) 이여서 단어 등록을 스킵했습니다');
        return;
      }
      NewMyWordController.to.loadMyWords();
      SnackBarHelper.showSuccessSnackBar(
        '중복 단어를 제외하고 $savedWordCnt개의 단어가 등록되었습니다',
      );
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('엑셀 처리 중 오류: $e', isLog: true);
    } finally {
      _isLoading.value = false;
    }

    // if (savedWordNumber != 0) {
    //   Get.back();
    //   Get.back();

    //   SnackBarHelper.showSuccessSnackBar(
    //     '$savedWordNumber개의 단어가 저장되었습니다.\n($savedWordNumber 단어가 이미 저장되어 있습니다.)',
    //   );

    //   UserController.to.updateMyWordSavedCount(
    //     true,
    //     isYokumatiageruWord: false,
    //     count: savedWordNumber,
    //   );
    //   return;
    // }
  }

  final wordFormKey = GlobalKey<FormState>();
  final exampleFormKey = GlobalKey<FormState>();

  late TextEditingController japaneseController;
  late TextEditingController yomikataController;
  late TextEditingController meanController;
  late TextEditingController exampleController;

  late FocusNode japaneseFocusNode;
  late FocusNode yomikataFocusNode;
  late FocusNode meanFocusNode;
  // late FocusNode exampleFocusNode;

  final _examples = <Example>[].obs;
  List<Example> get examples => _examples.value;
  late TextEditingController exampleWordController;
  late TextEditingController exampleMeanController;

  late FocusNode exampleWordFocusNode;
  late FocusNode exampleMeanFocusNode;

  bool isDropdownButtonOpen = false;
  void onTapExternalType(ExternalDictType? type) async {
    toggleExternalDictType(type);
    String sUrl;
    String query;
    switch (externalDictType.value) {
      case ExternalDictType.naver:
        sUrl = 'https://ja.dict.naver.com/#/';
        query = meanController.text;
        if (query.isEmpty) {
          query = japaneseController.text;
        }
        if (query.isNotEmpty) {
          sUrl += 'search?query=$query';
        }
        break;
      case ExternalDictType.papago:
        sUrl = 'http://papago.naver.com/';

        if (meanController.text.isNotEmpty) {
          query = meanController.text;
          sUrl += '?sk=ko&tk=ja&hn=1&st=$query';
        } else if (japaneseController.text.isNotEmpty) {
          query = japaneseController.text;
          sUrl += '?sk=ja&tk=ko&hn=1&st=$query';
        }

        break;
    }
    if (isDropdownButtonOpen) {
      Get.back();
    }

    // FocusManager.instance.primaryFocus!.unfocus();

    final url = Uri.parse(sUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppBrowserView, // ✅ 외부 브라우저
      );
    } else {
      SnackBarHelper.showErrorSnackBar('브라우저를 열 수 없습니다.');
    }
  }

  void openNaverDictionary() async {
    String sUrl = 'https://ja.dict.naver.com/#/';

    String query = meanController.text;
    if (query.isEmpty) {
      query = japaneseController.text;
    }

    if (query.isNotEmpty) {
      sUrl += 'search?query=$query';
    }

    final url = Uri.parse(sUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppBrowserView, // ✅ 외부 브라우저
      );
    } else {
      SnackBarHelper.showErrorSnackBar('브라우저를 열 수 없습니다.');
    }
  }

  @override
  void onInit() {
    japaneseController = TextEditingController();
    yomikataController = TextEditingController();
    meanController = TextEditingController();
    exampleController = TextEditingController();

    japaneseFocusNode = FocusNode();
    yomikataFocusNode = FocusNode();
    meanFocusNode = FocusNode();
    // exampleFocusNode = FocusNode();

    japaneseFocusNode.addListener(() => _onFocusChange(TextInputEnum.JAPANESE));
    yomikataFocusNode.addListener(() => _onFocusChange(TextInputEnum.YOMIKATA));
    meanFocusNode.addListener(() => _onFocusChange(TextInputEnum.MEAN));

    exampleWordController = TextEditingController();
    exampleMeanController = TextEditingController();

    exampleWordFocusNode = FocusNode();
    exampleMeanFocusNode = FocusNode();

    exampleWordFocusNode.addListener(
      () => _onFocusChange(TextInputEnum.EXAMPLE_JAPANESE),
    );
    exampleMeanFocusNode.addListener(
      () => _onFocusChange(TextInputEnum.EXAMPLE_MEAN),
    );
    super.onInit();
  }

  TextInputEnum currentFocus = TextInputEnum.JAPANESE;
  void _onFocusChange(TextInputEnum currentFocus) {
    this.currentFocus = currentFocus;
  }

  ScrollController scrollController = ScrollController();

  void scrollGoToBottom() {
    if (!scrollController.hasClients) return; // 안전 체크

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    japaneseController.dispose();
    yomikataController.dispose();
    meanController.dispose();
    exampleController.dispose();

    japaneseFocusNode.dispose();
    yomikataFocusNode.dispose();
    meanFocusNode.dispose();

    exampleWordController.dispose();
    exampleMeanController.dispose();
    exampleWordFocusNode.dispose();
    exampleMeanFocusNode.dispose();
    super.onClose();
  }

  void deleteExample(int index) {
    _examples.removeAt(index);
  }

  bool appendExample() {
    String eJapanese = exampleWordController.text.trim();
    String eMean = exampleMeanController.text.trim();
    if (eJapanese.isEmpty && eMean.isEmpty) return true;
    if (exampleFormKey.currentState!.validate()) {
      Example example = Example(word: eJapanese, mean: eMean);

      _examples.add(example);

      exampleWordController.clear();
      exampleMeanController.clear();

      exampleWordFocusNode.requestFocus();
      scrollGoToBottom();
      return true;
    }
    return false;
  }

  String? customValidator({
    String? value,
    required TextInputEnum textInputEnum,
  }) {
    switch (textInputEnum) {
      case TextInputEnum.JAPANESE:
        if (value == null || value.isEmpty) {
          japaneseFocusNode.requestFocus();
          return '${textInputEnum.name}을 입력해주세요.';
        }
        return null;
      // return '일본어';
      case TextInputEnum.YOMIKATA:
        if (value == null || value.isEmpty) {
          yomikataFocusNode.requestFocus();
          return '${textInputEnum.name}을 입력해주세요.';
        }
        return null;

      case TextInputEnum.MEAN:
        if (value == null || value.isEmpty) {
          meanFocusNode.requestFocus();
          return '${textInputEnum.name}을 입력해주세요.';
        }
        return null;

      case TextInputEnum.EXAMPLE_MEAN:
        if (value == null || value.isEmpty) {
          exampleMeanFocusNode.requestFocus();
          return '${textInputEnum.name}을 입력해주세요.';
        }
        return null;
      case TextInputEnum.EXAMPLE_JAPANESE:
        if (value == null || value.isEmpty) {
          exampleWordFocusNode.requestFocus();
          return '${textInputEnum.name}을 입력해주세요.';
        }
        return null;
    }
  }
}
