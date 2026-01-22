import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.label,
    this.maxLines,
    this.readOnly,
    this.controller,
    this.sufficIcon,
    this.hintText,
    this.keyboardType,
    this.hintStyle,
    this.color,
    this.autofocus,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
    this.needContentPadding,
  });
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool? autofocus;
  final bool? readOnly;
  final String? label;
  final String? hintText;
  final Color? color;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextStyle? hintStyle;
  final TextInputAction? textInputAction;
  final Widget? sufficIcon;
  final bool? needContentPadding;
  final Function()? onEditingComplete;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 13),
      focusNode: focusNode,
      controller: controller,
      autofocus: autofocus ?? false,
      readOnly: readOnly ?? false,
      maxLines: maxLines,
      onEditingComplete: onEditingComplete,

      decoration: InputDecoration(
        hintText: hintText,
        fillColor: SettingController.to.blackOrWhite,
        filled: true,
        label: Text(label ?? ''),
        floatingLabelStyle: TextStyle(
          color: color ?? SettingController.to.mainBordColor,
        ),
        contentPadding:
            needContentPadding == null
                ? null
                : EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        suffixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
        labelStyle: TextStyle(color: Colors.grey, fontSize: 13),
        enabledBorder: _border(),
        focusedBorder: _border(),
        suffixIcon:
            sufficIcon != null
                ? Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: sufficIcon,
                )
                : null,
      ),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey),
    );
  }
}
