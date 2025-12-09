import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class CheckRowBtn extends StatelessWidget {
  const CheckRowBtn({
    super.key,
    this.isPad,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool? isPad;
  final bool value;
  final Function(bool?) onChanged;
  final String label;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: SettingController.to.mainColor,
        ),
      ),
      trailing: Transform.scale(
        scale: 1,
        child: Checkbox(
          value: value,
          onChanged: onChanged,
          checkColor: Colors.cyan.shade600,
          fillColor: WidgetStateProperty.resolveWith(
            (states) => Colors.grey[200],
          ),
        ),
      ),
    );
  }
}
