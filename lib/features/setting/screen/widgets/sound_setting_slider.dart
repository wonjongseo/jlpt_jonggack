import 'package:flutter/material.dart';

class SoundSettingSlider extends StatelessWidget {
  const SoundSettingSlider({
    super.key,
    required this.value,
    required this.option,
    required this.label,
    required this.activeColor,
    required this.onChangeEnd,
    required this.onChanged,
  });

  final double value;
  final String option;
  final String label;
  final Color activeColor;
  final Function(double) onChangeEnd;
  final Function(double) onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(option, style: TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: Slider(
              value: value,
              onChangeEnd: onChangeEnd,
              onChanged: onChanged,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              activeColor: activeColor,
              label: label,
            ),
          ),
        ],
      ),
    );
  }
}
