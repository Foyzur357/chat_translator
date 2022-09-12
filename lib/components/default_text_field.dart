import 'package:chat_translator/utils/color_const.dart';
import 'package:flutter/material.dart';

class DefaultTextField extends StatefulWidget {
  const DefaultTextField({
    Key? key,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.errorText,
    this.onChanged,
    this.controller,
    this.validator,
    this.autoFocus = false,
    this.enabled = true,
    this.suffixIcon,
    this.fillColor,
    this.borderRadius,
    this.borderColor,
  }) : super(key: key);

  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autoFocus;
  final Function? onChanged;
  final Function? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final IconButton? suffixIcon;
  final TextEditingController? controller;
  final bool? enabled;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderRadius;

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<DefaultTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator as String? Function(String?)?,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      onChanged: widget.onChanged as void Function(String)?,
      autofocus: widget.autoFocus,
      enabled: widget.enabled,
      style: Theme.of(context).textTheme.caption,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        contentPadding: const EdgeInsets.all(15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 30),
          borderSide: BorderSide(color: widget.borderColor ?? Colors.transparent, width: 0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 30),
          borderSide: BorderSide(color: widget.borderColor ?? Colors.transparent, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 30),
          borderSide: BorderSide(color: widget.borderColor ?? Colors.transparent, width: 0.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 30),
          borderSide: BorderSide(color: widget.borderColor ?? Colors.transparent, width: 0.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 30),
          borderSide: BorderSide(color: widget.borderColor ?? Colors.transparent, width: 0.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 30),
          borderSide: BorderSide(color: widget.borderColor ?? Colors.transparent, width: 0.5),
        ),
        filled: true,
        fillColor: widget.fillColor ?? kColorsWhite.withOpacity(0.8),
        hintStyle: TextStyle(color: kBrandSubtitle.withOpacity(0.5)),
        errorStyle: TextStyle(color: Colors.red[600], fontWeight: FontWeight.bold, fontSize: 10),
        hintText: widget.hintText,
        // errorText: widget.errorText,
      ),
    );
  }
}
