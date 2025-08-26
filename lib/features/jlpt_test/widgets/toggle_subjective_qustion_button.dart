import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/features/jlpt_test/controller/jlpt_test_controller.dart';
import 'package:jlpt_jonggack/features/setting/services/setting_controller.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';

class ToggleSubjectiveQustionButton extends StatelessWidget {
  const ToggleSubjectiveQustionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('주관식 문제'),
        Transform.scale(
          scale: 1,
          child: Checkbox(
            value: SettingController.to.isSubjective,
            onChanged: (v) {
              JlptTestController.to.toggleSubjective();
            },
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
