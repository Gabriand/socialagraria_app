import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/views/screens/welcome.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tinder Agrario',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(elevation: 0),
      ),
      home: Welcome(),
    );
  }
}
