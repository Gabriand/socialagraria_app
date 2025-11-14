import 'package:flutter/material.dart';
import 'package:tinder_agro/core/app_colors.dart';

class CardWidget extends StatelessWidget {
  final double height;
  final double? width;
  final Widget child;
  final EdgeInsetsGeometry? margin;

  const CardWidget({
    super.key,
    this.width,
    required this.height,
    required this.child,
    this.margin = const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(25.0),
      ),
      margin: margin,
      child: child,
    );
  }
}
