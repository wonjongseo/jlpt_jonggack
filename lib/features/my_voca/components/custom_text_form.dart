import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/my_voca/screens/save_voca_screen.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    super.key,
    required this.textController,
    required this.focusNode,
    required this.textInputEnum,
    required this.isFocus,
    this.validator,
    this.onFieldSubmitted,
  });

  final TextInputEnum textInputEnum;
  final TextEditingController textController;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final void Function(String?)? onFieldSubmitted;
  final bool isFocus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        textInputAction:
            textInputEnum == TextInputEnum.mean ||
                    textInputEnum == TextInputEnum.exampleMean
                ? TextInputAction.done
                : TextInputAction.next,
        style: TextStyle(fontFamily: AppFonts.japaneseFont, fontSize: 14),
        onChanged: validator,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        autofocus: textInputEnum == TextInputEnum.japanese,
        decoration: InputDecoration(
          hintText: textInputEnum.name,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.mainColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: outlineErrorBorder(),
          errorBorder: outlineErrorBorder(),
        ),
        controller: textController,
        focusNode: focusNode,
      ),
    );
  }

  OutlineInputBorder outlineErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.redAccent, width: 2),
    );
  }
}
