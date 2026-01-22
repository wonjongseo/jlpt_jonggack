import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.label,
    this.borderRadius,
  });

  final String label;
  final double? borderRadius;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: SettingController.to.mainColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 5),
      ),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.width16,
            ),
          ),
        ),
      ),
    );
  }
}
