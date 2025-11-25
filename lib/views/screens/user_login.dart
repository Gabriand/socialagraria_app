import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/page_transitions.dart';
import 'package:social_agraria/views/screens/login.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school_outlined,
                size: AppDimens.iconSizeXLarge * 2.5,
                color: AppColors.primaryDarker,
              ),

              SizedBox(height: AppDimens.espacioLarge + 6),

              Text(
                "Bienvenido",
                style: TextStyle(
                  fontSize: AppDimens.fontSizeTitleLarge + 4,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDarker,
                ),
              ),

              SizedBox(height: AppDimens.espacioSmall + 2),

              Text(
                "Tu espacio exclusivo para conectar en la universidad.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.fontSizeSubtitle - 1,
                  color: AppColors.primaryDarker,
                ),
              ),

              SizedBox(height: AppDimens.spacing2XLarge),

              Container(
                width: double.infinity,
                height: AppDimens.buttonHeightMedium + 2,
                decoration: BoxDecoration(
                  color: AppColors.primaryDarker,
                  borderRadius: BorderRadius.circular(
                    AppDimens.radiusMedium - 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/icon-google.png',
                      width: AppDimens.iconSizeLarge - 2,
                      height: AppDimens.iconSizeLarge - 2,
                    ),
                    SizedBox(width: AppDimens.espacioSmall + 2),
                    Text(
                      "Ingresar con Google",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: AppDimens.fontSizeSubtitle,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimens.espacioLarge - 4),

              GestureDetector(
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(PageTransitions.slideFromRight(const Login()));
                },
                child: Container(
                  width: double.infinity,
                  height: AppDimens.buttonHeightMedium + 2,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(
                      AppDimens.radiusMedium - 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Ingresar con Cuenta",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: AppDimens.fontSizeSubtitle,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppDimens.espacioXLarge + 3),

              const Text(
                "Al ingresar, aceptas nuestros Términos de Servicio y\nPolítica de Privacidad.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
