import 'package:flutter/material.dart';
import 'package:practice_7/utils/extension.dart';

class TextFieldName extends StatelessWidget {
  final String labelText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const TextFieldName({
    super.key,
    required this.labelText,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        labelText: labelText,
        contentPadding: EdgeInsets.symmetric(
          vertical: context.scrnHeight * 0.02,
          horizontal: context.scrnWidth * 0.02,
        ),
      ),
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }
}
