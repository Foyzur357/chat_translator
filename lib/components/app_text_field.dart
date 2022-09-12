import 'package:chat_translator/utils/color_const.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final bool enabled;
  final FocusNode? focusNode;
  final int? characterLength;
  final Widget? prefix;
  final String? Function(String?)? validator;
  TextInputField({
    this.controller,
    required this.label,
    this.enabled = true,
    this.focusNode,
    this.characterLength,
    this.prefix,
    this.hintText,
    this.validator,
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      validator: widget.validator,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      minLines: 1,
      maxLines: 6,
      decoration: InputDecoration(
        enabled: widget.enabled,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(color: Colors.grey[800]),
        labelText: widget.label,
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.all(18.0),
        errorStyle: const TextStyle(
          color: AppColors.errorColor,
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(
            color: Color(0xffE2E8F0),
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(
            color: Color(0xffE2E8F0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(
            color: Color(0xffE2E8F0),
          ),
        ),
        prefixIcon: widget.prefix,
      ),
    );
  }
}
