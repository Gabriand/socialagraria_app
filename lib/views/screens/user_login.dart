import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';

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
              const Icon(
                Icons.school_outlined,
                size: 120.0,
                color: AppColors.primaryDarker,
              ),

              const SizedBox(height: 30),

              const Text(
                "Bienvenido",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDarker,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Tu espacio exclusivo para conectar en la universidad.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: AppColors.primaryDarker),
              ),

              const SizedBox(height: 40),

              Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.primaryDarker,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/icon-google.png',
                      width: 28,
                      height: 28,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Ingresar con Google",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    "Ingresar con Cuenta",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

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
