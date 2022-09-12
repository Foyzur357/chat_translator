import 'package:flutter/material.dart';

class DefaultContainer extends StatelessWidget {
  final Widget? child;
  final Function? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  const DefaultContainer({
    Key? key,
    this.child,
    this.padding,
    this.onTap,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 3.0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
