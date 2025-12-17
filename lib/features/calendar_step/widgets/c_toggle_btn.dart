import 'package:flutter/material.dart';

import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class CToggleBtn extends StatelessWidget {
  const CToggleBtn({
    super.key,
    required this.onChanged,
    required this.value,
    required this.label,
  });

  final String label;
  final ValueChanged<bool> onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final main = SettingController.to.mainColor;

    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: main,
        ),
      ),
      trailing: ToggleButtons(
        borderRadius: BorderRadius.circular(20),
        constraints: const BoxConstraints(minHeight: 32, minWidth: 52),
        onPressed: (index) {
          // index 0 = OFF, index 1 = ON
          onChanged(index == 1);
        },
        isSelected: [!value, value],
        selectedBorderColor: main,
        borderColor: main.withOpacity(0.35),
        fillColor: main.withOpacity(0.15),
        selectedColor: main,
        color: main.withOpacity(0.8),
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'OFF',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'ON',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
