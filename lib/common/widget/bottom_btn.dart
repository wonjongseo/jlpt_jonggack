import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/config/colors.dart';

class BottomBtn extends StatelessWidget {
  const BottomBtn({super.key, required this.label, required this.onTap});

  final String label;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ).copyWith(top: 4, bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
