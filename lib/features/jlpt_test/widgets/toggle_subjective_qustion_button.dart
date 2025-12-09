import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/core/app_string.dart';

class ToggleSubjectiveQustionButton extends StatelessWidget {
  const ToggleSubjectiveQustionButton({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final bool value;
  final Function(bool?) onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(AppString.openEnded.tr),
        Transform.scale(
          scale: 1,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            checkColor: Colors.cyan.shade600,
            fillColor: WidgetStateProperty.resolveWith(
              (states) => Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
