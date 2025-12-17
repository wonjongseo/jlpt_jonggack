import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/grammar_step/services/grammar_controller.dart';
import 'package:jlpt_jonggack/features/grammar_step/widgets/gammar_card_details.dart';
import 'package:jlpt_jonggack/features/setting/controller/font_size_controller.dart';
import 'package:jlpt_jonggack/model/grammar.dart';

// OK
class GrammarListTile extends StatefulWidget {
  const GrammarListTile({
    super.key,
    required this.index,
    required this.grammars,
  });
  final int index;
  final List<Grammar> grammars;

  @override
  State<GrammarListTile> createState() => _GrammarListTileState();
}

class _GrammarListTileState extends State<GrammarListTile> {
  bool isWantToSee = false;

  void toggleWantToSee() {
    isWantToSee = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    GrammarController controller = Get.find<GrammarController>();
    return InkWell(
      onTap: () {
        Get.to(
          () => GrammarCardDetails(
            grammars: widget.grammars,
            index: widget.index,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 0.3)),
        child: ListTile(
          isThreeLine: true,
          minLeadingWidth: 150,
          title: Text(
            widget.grammars[widget.index].grammar,
            style: TextStyle(
              fontSize: FSController.to.baseFS + 2,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
              fontFamily: AppFonts.japaneseFont,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: SizedBox(
              child:
                  isWantToSee || controller.isSeeMean
                      ? Text(
                        widget.grammars[widget.index].means,
                        style: TextStyle(
                          fontSize: FSController.to.baseFS,
                          fontFamily: AppFonts.descriptionFont,
                        ),
                      )
                      : InkWell(
                        onTap: toggleWantToSee,
                        child: Container(
                          height: 25,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
