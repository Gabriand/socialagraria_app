import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';

class RestorePassword extends StatefulWidget {
  const RestorePassword({super.key});

  @override
  State<RestorePassword> createState() => _RestorePasswordState();
}

class _RestorePasswordState extends State<RestorePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: AppColors.primaryDarker,
                    ),
                  ),
                ],
              ),

              Text(
                "Recuperar Contraseña",
                style: TextStyle(
                  fontSize: AppDimens.fontSizeTitleLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDarker,
                ),
              ),

              SizedBox(height: AppDimens.spacing2XLarge),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  "Ingresa tu correo electrónico universitario para recibir las instrucciones "
                  "y restablecer tu contraseña.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeSubtitle,
                    color: AppColors.primaryDarker,
                    height: 1.4,
                  ),
                ),
              ),

              SizedBox(height: AppDimens.spacing2XLarge),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Correo Electrónico",
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeSubtitle,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarker,
                  ),
                ),
              ),

              SizedBox(height: AppDimens.espacioSmall),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  border: Border.all(color: AppColors.primaryDarker, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "tucorreo@universidad.edu",
                          hintStyle: TextStyle(
                            color: AppColors.accent,
                            fontSize: AppDimens.fontSizeSubtitle,
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.email_outlined,
                      color: AppColors.primaryDarker,
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimens.spacing2XLarge),

              SizedBox(
                width: double.infinity,
                height: AppDimens.buttonHeightLarge,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDarker,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusMedium,
                      ),
                    ),
                  ),
                  child: Text(
                    "Enviar Instrucciones",
                    style: TextStyle(
                      fontSize: AppDimens.fontSizeSubtitle,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Text(
                    "¿Recuerdas tu contraseña? Inicia Sesión",
                    style: TextStyle(
                      color: AppColors.primaryDarker,
                      fontSize: AppDimens.fontSizeBody,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryDarker,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
