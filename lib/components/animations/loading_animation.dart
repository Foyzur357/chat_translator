import 'dart:math';

import 'package:chat_translator/utils/color_const.dart';
import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> rotationAnimation;
  late Animation<double> radiusInAnimation;
  late Animation<double> radiusOutAnimation;

  final double initialRadius = 30;
  double radius = 0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );
    radiusInAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn),
      ),
    );
    radiusOutAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );

    animationController.addListener(() {
      setState(() {
        if (animationController.value >= 0.75 && animationController.value <= 1.0) {
          radius = radiusInAnimation.value * initialRadius;
        } else if (animationController.value >= 0.0 && animationController.value <= 0.25) {
          radius = radiusOutAnimation.value * initialRadius;
        }
      });
    });
    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: Center(
        child: RotationTransition(
          turns: rotationAnimation,
          child: Stack(
            children: [
              Dot(
                radius: 30,
                color: AppColors.primaryColor,
              ),
              Transform.translate(
                offset: Offset(radius * cos(pi / 4), radius * sin(pi / 4)),
                child: Dot(
                  radius: 5,
                  color: AppColors.primaryColor,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(2 * pi / 4), radius * sin(2 * pi / 4)),
                child: Dot(
                  radius: 5,
                  color: AppColors.errorColor,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(3 * pi / 4), radius * sin(3 * pi / 4)),
                child: Dot(
                  radius: 5,
                  color: AppColors.primaryColor,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(4 * pi / 4), radius * sin(4 * pi / 4)),
                child: Dot(
                  radius: 5,
                  color: AppColors.errorColor,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(5 * pi / 4), radius * sin(5 * pi / 4)),
                child: Dot(
                  radius: 5,
                  color: AppColors.primaryColor,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(6 * pi / 4), radius * sin(6 * pi / 4)),
                child: Dot(
                  radius: 5,
                  color: AppColors.errorColor,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(7 * pi / 4), radius * sin(7 * pi / 4)),
                child: Dot(
                  radius: 5,
                  color: AppColors.primaryColor,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(8 * pi / 4), radius * sin(8 * pi / 4)),
                child: Dot(
                  radius: 5,
                  color: AppColors.errorColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;
  const Dot({Key? key, required this.radius, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
