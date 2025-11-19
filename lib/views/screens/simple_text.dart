import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';

class SimpleText extends StatelessWidget {
  final String title;
  final String body;

  const SimpleText({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.primaryDarker,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          body,
          style: TextStyle(fontSize: 16, color: AppColors.primaryDarker),
        ),
      ),
    );
  }
}
