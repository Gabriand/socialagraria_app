import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/page_transitions.dart';
import 'package:social_agraria/views/screens/user_login.dart';
import 'package:social_agraria/views/screens/simple_text.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 130.0,
              height: 130.0,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(AppDimens.radiusRound),
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
                fontSize: AppDimens.fontSizeTitleLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimens.spacing2XLarge),
            ElevatedButton(
              onPressed: () => Navigator.of(
                context,
              ).push(PageTransitions.fade(const UserLogin())),
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
            SizedBox(height: 40.0),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageTransitions.slideFromBottom(
                    const SimpleText(
                      title: 'Términos y Condiciones',
                      body:
                          'Aquí van los términos y condiciones de uso de la aplicación...',
                    ),
                  ),
                );
              },
              child: Text(
                'Terminos y politica de privacidad',
                style: TextStyle(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
