import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/setting/controller/font_size_controller.dart';

class GrammarDescriptionCard extends StatefulWidget {
  const GrammarDescriptionCard({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  State<GrammarDescriptionCard> createState() => _GrammarDescriptionCardState();
}

class _GrammarDescriptionCardState extends State<GrammarDescriptionCard> {
  bool isSeen = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            isSeen = !isSeen;
            setState(() {});
          },
          child: Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: FSController.to.baseFS + 3,
                ),
              ),
              Icon(
                isSeen
                    ? Icons.arrow_drop_up_rounded
                    : Icons.arrow_drop_down_rounded,
              ),
            ],
          ),
        ),
        if (isSeen)
          Text(
            widget.content,
            style: TextStyle(
              fontFamily: AppFonts.descriptionFont,
              fontSize: FSController.to.baseFS,
            ),
          ),
        if (isSeen) SizedBox(height: Responsive.height10 * 1.5),
        SizedBox(height: 8),
      ],
    );
  }
}
