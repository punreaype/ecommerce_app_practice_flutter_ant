import 'package:flutter/material.dart';
import 'package:practice_7/utils/extension.dart';

class TextFieldPassword extends StatefulWidget {
  final String labelText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const TextFieldPassword({
    super.key,
    required this.labelText,
    this.validator,
    this.controller,
  });

  @override
  _TextFieldPasswordState createState() => _TextFieldPasswordState();
}

class _TextFieldPasswordState extends State<TextFieldPassword> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: !isVisible,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        labelText: widget.labelText,
        suffixIcon: IconButton(
          icon: Icon(
            isVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              isVisible = !isVisible;
            });
          },
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: context.scrnHeight * 0.02,
          horizontal: context.scrnWidth * 0.02,
        ),
      ),
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }
}
