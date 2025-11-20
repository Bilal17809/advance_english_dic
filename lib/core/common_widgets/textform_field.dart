import 'package:flutter/material.dart';

// class CustomTextFormField extends StatelessWidget {
//   final String hintText;
//   final TextEditingController? controller;
//   final FocusNode? focusNode;
//   final TextInputType? keyboardType;
//   final bool obscureText;
//   final TextStyle? style;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final InputBorder? border;
//   final InputBorder? focusedBorder;
//   final InputBorder? enabledBorder;
//   final Function(String)? onChanged;
//   final Function(String?)? onSaved;
//   final String? Function(String?)? validator;
//   final TextAlign textAlign;
//   final TextAlignVertical textAlignVertical;
//
//   const CustomTextFormField({
//     super.key,
//     required this.hintText,
//     this.controller,
//     this.focusNode,
//     this.keyboardType,
//     this.obscureText = false,
//     this.style,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.border,
//     this.focusedBorder,
//     this.enabledBorder,
//     this.onChanged,
//     this.onSaved,
//     this.validator,
//     this.textAlign = TextAlign.center,
//     this.textAlignVertical = TextAlignVertical.center,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       focusNode: focusNode,
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//       style: style,
//       textAlign: textAlign,
//       textAlignVertical: textAlignVertical,
//       onChanged: onChanged,
//       onSaved: onSaved,
//       validator: validator,
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: TextStyle(
//           color: Colors.grey.shade500,
//         ),
//         alignLabelWithHint: true,
//         isCollapsed: false,
//         contentPadding: const EdgeInsets.all(12),
//         prefixIcon: prefixIcon,
//         suffixIcon: suffixIcon,
//         border: border ?? InputBorder.none,
//         focusedBorder: focusedBorder ?? InputBorder.none,
//         enabledBorder: enabledBorder ?? InputBorder.none,
//       ),
//     );
//   }
// }
class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextStyle? style;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final Color? fillColor;
  final Color? hintTextColor;
  final Color? cursorColor;

  /// ✅ NEW: Text color
  final Color? textColor;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.style,
    this.prefixIcon,
    this.suffixIcon,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.textAlign = TextAlign.center,
    this.textAlignVertical = TextAlignVertical.center,
    this.fillColor,
    this.hintTextColor,
    this.cursorColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,

      /// ✅ Apply text color via TextStyle
      style: style ?? TextStyle(color: textColor ?? Colors.black),

      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,

      /// ✅ Apply cursor color
      cursorColor: cursorColor ?? Theme.of(context).textSelectionTheme.cursorColor,

      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintTextColor,
        ),
        alignLabelWithHint: true,
        isCollapsed: false,
        contentPadding: const EdgeInsets.all(12),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: border ?? InputBorder.none,
        focusedBorder: focusedBorder ?? InputBorder.none,
        enabledBorder: enabledBorder ?? InputBorder.none,
      ),
    );
  }
}
