import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
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
      SnackBarHelper.showSuccessSnackBar(
        '${myword.getWord()}${AppString.savedWord.tr}',
      );

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
        SnackBarHelper.showErrorSnackBar(AppString.skipUploadWord.tr);
        return;
      }

      NewMyWordController.to.loadMyWords();
      SnackBarHelper.showSuccessSnackBar(
        isEn
            ? "$savedWordCnt ${savedWordCnt == 1 ? "word" : "words"} have been added."
            : '$savedWordCnt개의 단어가 등록되었습니다',
      );
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(
        '${AppString.errorUploadingWord.tr}$e',
        isLog: true,
      );
    } finally {
      _isLoading.value = false;
    }
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

  Future<void> onTapExternalType(ExternalDictType? type) async {
    toggleExternalDictType(type);

    String? sUrl;
    String query = '';

    final mean = meanController.text.trim();
    final jp = japaneseController.text.trim();

    if (isKo) {
      // 한국어 사용자: Naver / Papago
      switch (externalDictType.value) {
        case ExternalDictType.naver:
          sUrl =
              'https://ja.dict.naver.com/#/search?query=${Uri.encodeComponent(mean.isNotEmpty ? mean : jp)}';
          break;

        case ExternalDictType.papago:
          if (mean.isNotEmpty) {
            // ko -> ja
            sUrl =
                'https://papago.naver.com/?sk=ko&tk=ja&hn=1&st=${Uri.encodeComponent(mean)}';
          } else if (jp.isNotEmpty) {
            // ja -> ko
            sUrl =
                'https://papago.naver.com/?sk=ja&tk=ko&hn=1&st=${Uri.encodeComponent(jp)}';
          }
          break;
      }
    } else {
      switch (externalDictType.value) {
        case ExternalDictType.naver:
          if (mean.isNotEmpty) {
            // ko -> ja
            sUrl =
                'https://translate.google.com/?sl=en&tl=ja&text=${Uri.encodeComponent(mean)}&op=translate';
          } else if (jp.isNotEmpty) {
            // ja -> ko
            sUrl =
                'https://translate.google.com/?sl=ja&tl=en&text=${Uri.encodeComponent(jp)}&op=translate';
          }
          break;

        case ExternalDictType.papago:
          // == DeepL
          if (mean.isNotEmpty) {
            sUrl =
                'https://www.deepl.com/translator#en/ja/${Uri.encodeComponent(mean)}';
          } else if (jp.isNotEmpty) {
            sUrl =
                'https://www.deepl.com/translator#ja/en/${Uri.encodeComponent(jp)}';
          }
          break;
      }
    }

    if (isDropdownButtonOpen) {
      Get.back();
    }

    if (sUrl == null || sUrl.isEmpty) {
      SnackBarHelper.showErrorSnackBar(AppString.plzEnterSearchTerm.tr);
      return;
    }

    final url = Uri.parse(sUrl);
    if (await canLaunchUrl(url)) {
      final ok = await launchUrl(
        url,
        mode: LaunchMode.inAppBrowserView, // 인앱 브라우저
      );
      if (!ok) {
        SnackBarHelper.showErrorSnackBar(AppString.cannotOpenBraoser.tr);
      }
    } else {
      SnackBarHelper.showErrorSnackBar(AppString.cannotOpenBraoser.tr);
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

    japaneseFocusNode.addListener(() => _onFocusChange(TextInputEnum.japanese));
    yomikataFocusNode.addListener(() => _onFocusChange(TextInputEnum.yomikata));
    meanFocusNode.addListener(() => _onFocusChange(TextInputEnum.mean));

    exampleWordController = TextEditingController();
    exampleMeanController = TextEditingController();

    exampleWordFocusNode = FocusNode();
    exampleMeanFocusNode = FocusNode();

    exampleWordFocusNode.addListener(
      () => _onFocusChange(TextInputEnum.exampleSentence),
    );
    exampleMeanFocusNode.addListener(
      () => _onFocusChange(TextInputEnum.exampleMean),
    );
    super.onInit();
  }

  TextInputEnum currentFocus = TextInputEnum.japanese;
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
      case TextInputEnum.japanese:
        if (value == null || value.isEmpty) {
          japaneseFocusNode.requestFocus();
          return '${textInputEnum.name} ${isEn ? 'is Required.' : '를 입력해주세요.'}';
        }
        return null;
      // return '일본어';
      case TextInputEnum.yomikata:
        if (value == null || value.isEmpty) {
          yomikataFocusNode.requestFocus();
          return '${textInputEnum.name} ${isEn ? 'is Required.' : '를 입력해주세요.'}';
        }
        return null;

      case TextInputEnum.mean:
        if (value == null || value.isEmpty) {
          meanFocusNode.requestFocus();
          return '${textInputEnum.name} ${isEn ? 'is Required.' : '를 입력해주세요.'}';
        }
        return null;

      case TextInputEnum.exampleMean:
        if (value == null || value.isEmpty) {
          exampleMeanFocusNode.requestFocus();
          return '${textInputEnum.name} ${isEn ? 'is Required.' : '를 입력해주세요.'}';
        }
        return null;
      case TextInputEnum.exampleSentence:
        if (value == null || value.isEmpty) {
          exampleWordFocusNode.requestFocus();
          return '${textInputEnum.name} ${isEn ? 'is Required.' : '를 입력해주세요.'}';
        }
        return null;
    }
  }
}
