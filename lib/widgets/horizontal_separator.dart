import 'package:flutter/material.dart';

class SeparatorhWidget extends StatelessWidget {
  final double horizontalSpacing;
  final double? width;

  const SeparatorhWidget({
    super.key,
    required this.width,
    this.horizontalSpacing = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalSpacing),
      child: Center(
        child: Container(
          height: 1.0,
          width: width,
          decoration: const BoxDecoration(color: Colors.black12),
        ),
      ),
    );
  }
}
