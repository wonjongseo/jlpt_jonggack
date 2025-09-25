import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/widgets/date_picker_bottom_sheet.dart';
import 'package:jlpt_jonggack/model/my_word.dart';

class MyVocaDateSection extends StatelessWidget {
  const MyVocaDateSection({
    super.key,
    required this.date,
    required this.words,
    required this.onTap,
    required this.onScrollLeft,
    required this.onScrollRight,
  });
  final DateTime date;
  final List<MyWord> words;
  final Function(int) onTap;
  final Function(int) onScrollLeft;
  final Function(int) onScrollRight;

  @override
  Widget build(BuildContext context) {
    final header = DateFormat("yyyy년 M월 d일").format(date);
    return ExpansionTile(
      initiallyExpanded: true,
      childrenPadding: EdgeInsets.all(8),
      shape: Border.all(color: Colors.transparent),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: header,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' (${words.length}개)'),
          ],
        ),
      ),

      children: List.generate(words.length, (index) {
        final w = words[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: GetBuilder<NewMyWordController>(
            builder: (controller) {
              Color textColor = w.isKnown ? Colors.white : Colors.black;
              return Slidable(
                startActionPane: _startActionPane(w, index),
                endActionPane: _endActionPane(index),
                child: Container(
                  padding: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: w.isKnown ? AppColors.mainColor : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    isThreeLine: true,
                    onTap: () => onTap(index),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          w.word,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: AppFonts.japaneseFont,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 16,
                          color: textColor,
                        ),
                      ],
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  w.mean,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  ActionPane _endActionPane(int index) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (context) {
            onScrollRight(index);
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: '단어 삭제',
        ),
      ],
    );
  }

  ActionPane _startActionPane(MyWord w, int index) {
    return ActionPane(
      motion: ScrollMotion(),
      children: [
        if (w.isKnown)
          SlidableAction(
            onPressed: (context) {
              onScrollLeft(index);
            },
            backgroundColor: Colors.grey,
            label: '미암기로 변경',
            icon: Icons.remove,
          )
        else
          SlidableAction(
            onPressed: (context) {
              onScrollLeft(index);
            },
            backgroundColor: AppColors.mainColor,
            label: '암기로 변경',
            icon: Icons.check,
            foregroundColor: Colors.white,
          ),
      ],
    );
  }
}
