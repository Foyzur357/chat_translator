import 'package:chat_translator/utils/color_const.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final Color? color;
  final Function onPressed;

  const DefaultButton({
    Key? key,
    required this.text,
    this.color,
    required this.onPressed,
    this.height = 50,
    this.width = 300,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? kBrandGreen,
        ),
        onPressed: onPressed as void Function()?,
        child: Text(
          text,
          style: const TextStyle(
            // fontSize: (height! / 1.9).sp,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
