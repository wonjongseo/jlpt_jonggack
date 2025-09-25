import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';

import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/my_voca/components/custom_text_form.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
import 'package:jlpt_jonggack/model/example.dart';
import 'package:jlpt_jonggack/model/my_word.dart';

TextStyle accentTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: AppColors.mainColor,
  fontSize: 16,
);

class ManualAddWordWidget extends StatefulWidget {
  static String name = '/new-add-my-word';
  const ManualAddWordWidget({super.key});

  @override
  State<ManualAddWordWidget> createState() => _ManualAddWordWidgetState();
}

class _ManualAddWordWidgetState extends State<ManualAddWordWidget> {
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

  List<Example> examples = [];
  late TextEditingController exampleWordController;
  late TextEditingController exampleMeanController;

  late FocusNode exampleWordFocusNode;
  late FocusNode exampleMeanFocusNode;

  @override
  void initState() {
    super.initState();

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

    examples = [];
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
  }

  TextInputEnum currentFocus = TextInputEnum.JAPANESE;
  void _onFocusChange(TextInputEnum currentFocus) {
    setState(() {
      this.currentFocus = currentFocus;
    });
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.all(8),
            child: Card(
              child: Form(
                key: wordFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      _wordTextForms(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _exampleTextForms(),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: List.generate(examples!.length, (
                                index,
                              ) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text(
                                        "${index + 1}. ${examples![index].word}",
                                        style: const TextStyle(
                                          fontFamily: AppFonts.japaneseFont,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        examples!.removeAt(index);
                                        setState(() {});
                                      },
                                      child: Text(
                                        "삭제",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: BottomBtn(label: '저장', onTap: addWord),
          ),
        ],
      ),
    );
  }

  void addWord() {
    if (wordFormKey.currentState!.validate()) {
      String japanese = japaneseController.text;
      String yomikata = yomikataController.text;
      String mean = meanController.text;

      if (!appendExample()) {
        return;
      }

      print('examples : ${examples}');
      final myword = MyWord(
        word: japanese,
        mean: mean,
        yomikata: yomikata,
        examples: examples,
        isManuelSave: true,
      );

      print('myword : ${myword}');

      NewMyWordController.to.manualSaveMyWord(myword);

      japaneseController.clear();
      yomikataController.clear();
      meanController.clear();

      japaneseFocusNode.requestFocus();

      examples.clear();
    }
  }

  @override
  void dispose() {
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
    super.dispose();
  }

  Widget _wordTextForms() {
    return Column(
      children: [
        CustomTextForm(
          textInputEnum: TextInputEnum.JAPANESE,
          textController: japaneseController,
          focusNode: japaneseFocusNode,
          isFocus: TextInputEnum.JAPANESE == currentFocus,
          validator: (value) {
            return customValidator(
              value: value,
              textInputEnum: TextInputEnum.JAPANESE,
            );
          },
        ),
        CustomTextForm(
          textInputEnum: TextInputEnum.YOMIKATA,
          textController: yomikataController,
          focusNode: yomikataFocusNode,
          isFocus: TextInputEnum.YOMIKATA == currentFocus,
          validator: (value) {
            return customValidator(
              value: value,
              textInputEnum: TextInputEnum.YOMIKATA,
            );
          },
        ),
        CustomTextForm(
          textInputEnum: TextInputEnum.MEAN,
          textController: meanController,
          focusNode: meanFocusNode,
          isFocus: TextInputEnum.MEAN == currentFocus,
          validator: (value) {
            return customValidator(
              value: value,
              textInputEnum: TextInputEnum.MEAN,
            );
          },
        ),
      ],
    );
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

  Widget _exampleTextForms() {
    return Form(
      key: exampleFormKey,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomTextForm(
            textInputEnum: TextInputEnum.EXAMPLE_JAPANESE,
            textController: exampleWordController,
            focusNode: exampleWordFocusNode,
            isFocus: TextInputEnum.EXAMPLE_JAPANESE == currentFocus,
            validator: (value) {
              return customValidator(
                value: value,
                textInputEnum: TextInputEnum.EXAMPLE_JAPANESE,
              );
            },
          ),
          CustomTextForm(
            textInputEnum: TextInputEnum.EXAMPLE_MEAN,
            textController: exampleMeanController,
            focusNode: exampleMeanFocusNode,
            isFocus: TextInputEnum.EXAMPLE_MEAN == currentFocus,
            validator: (value) {
              return customValidator(
                value: value,
                textInputEnum: TextInputEnum.EXAMPLE_MEAN,
              );
            },
            onFieldSubmitted: (v) => appendExample(),
          ),
          IconButton(
            onPressed: appendExample,
            icon: Text(
              "예제 추가",
              style: TextStyle(
                color: AppColors.mainBordColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool appendExample() {
    if (exampleFormKey.currentState!.validate()) {
      String eJapanese = exampleWordController.text;
      String eMean = exampleMeanController.text;

      Example example = Example(word: eJapanese, mean: eMean);

      examples.add(example);

      exampleWordController.clear();
      exampleMeanController.clear();

      exampleWordFocusNode.requestFocus();
      setState(() {});
      scrollGoToBottom();
      return true;
    }
    return false;
  }
}
