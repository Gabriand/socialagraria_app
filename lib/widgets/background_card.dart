import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';

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
    this.margin = const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(20),
            spreadRadius: 0,
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: margin,
      child: child,
    );
  }
}
