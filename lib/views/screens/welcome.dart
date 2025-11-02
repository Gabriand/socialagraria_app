import 'package:flutter/material.dart';
import 'package:tinder_agro/core/app_colors.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 130.0,
              height: 130.0,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Icon(
                Icons.school_outlined,
                size: 90.0,
                color: AppColors.primaryDarker,
              ),
            ),
            SizedBox(height: 230.0),
            Text(
              'La chispa universitaria empieza aquí!',
              style: TextStyle(
                fontSize: 31.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () => (),
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.white,
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 130.0,
                  vertical: 15.0,
                ),
              ),
              child: Text(
                'Empezar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () => (),
              child: Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Text(
              'Terminos y politica de privacidad',
              style: TextStyle(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
