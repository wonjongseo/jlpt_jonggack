import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/grammar_step/widgets/grammar_description_card.dart';
import 'package:jlpt_jonggack/features/grammar_test/components/grammar_example_card.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/grammar.dart';

class GrammarCard extends StatefulWidget {
  const GrammarCard({super.key, required this.grammar, this.myWordIcon});

  final Widget? myWordIcon;
  final Grammar grammar;
  @override
  State<GrammarCard> createState() => _GrammarCardState();
}

class _GrammarCardState extends State<GrammarCard> {
  bool isShowMoreExample = false;
  int maxLine = 1;
  @override
  void initState() {
    super.initState();

    maxLine = (widget.grammar.grammar.length / 18).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        widget.grammar.grammar,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.japaneseFont,
                          fontSize: 30,
                        ),
                        maxLines: maxLine,
                      ),
                    ),
                    if (widget.myWordIcon != null) widget.myWordIcon!,
                  ],
                ),
                SizedBox(height: 20),
                if (widget.grammar.means.isNotEmpty) ...[
                  GrammarDescriptionCard(
                    title: AppString.mean.tr,
                    content: widget.grammar.means,
                  ),
                ],
                if (widget.grammar.description.isNotEmpty) ...[
                  GrammarDescriptionCard(
                    title: AppString.description.tr,
                    content: widget.grammar.description,
                  ),
                ],
                if (widget.grammar.connectionWays.isNotEmpty) ...[
                  GrammarDescriptionCard(
                    title: AppString.connectionWays.tr,
                    content: widget.grammar.connectionWays,
                  ),
                ],
                const Divider(),
                SizedBox(height: 20),
                Text(
                  AppString.examples.tr,
                  style: TextStyle(
                    color: SettingController.to.mainBordColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(
                      isShowMoreExample ? widget.grammar.examples.length : 2,
                      (index2) {
                        return GrammarExampleCard(
                          index: index2,
                          examples: widget.grammar.examples,
                        );
                      },
                    ),
                    if (!isShowMoreExample)
                      TextButton(
                        onPressed: () {
                          isShowMoreExample = true;
                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          AppString.seeMoreExamples.tr,
                          style: TextStyle(
                            color: SettingController.to.mainBordColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: Responsive.height15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
