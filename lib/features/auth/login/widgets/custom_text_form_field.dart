import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.screenWidth,
    required this.fielldRatio,
    required this.hintText,
    required this.fieldIcon,
    required this.autovalidateMode,
    this.onSaved,
  });

  final double screenWidth;
  final double fielldRatio;

  final String hintText;
  final Icon fieldIcon;

  final AutovalidateMode autovalidateMode;
  final void Function(String?)? onSaved;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.screenWidth * widget.fielldRatio,
      child: TextFormField(
        onSaved: widget.onSaved,
        autovalidateMode: widget.autovalidateMode,
        decoration: InputDecoration(
          suffixIcon: widget.fieldIcon,
          suffixIconColor: Colors.black87,
          filled: true,
          fillColor: Colors.white,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
              color: Colors.black, fontSize: 16.0, fontFamily: "Questv1"),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}
