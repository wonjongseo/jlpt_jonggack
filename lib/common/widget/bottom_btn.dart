import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/config/colors.dart';

class BottomBtn extends StatelessWidget {
  const BottomBtn({
    super.key,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
  });

  final String label;
  final Function() onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ).copyWith(top: 4, bottom: 10),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.mainColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize ?? 18,
              fontWeight: FontWeight.w600,
              color: textColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
