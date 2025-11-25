import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';

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
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: AppColors.primaryDarker,
                    ),
                  ),
                ],
              ),

              const Text(
                "Recuperar Contraseña",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDarker,
                ),
              ),

              const SizedBox(height: 140),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  "Ingresa tu correo electrónico universitario para recibir las instrucciones "
                  "y restablecer tu contraseña.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryDarker,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Correo Electrónico",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarker,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.primaryDarker, width: 1),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "tucorreo@universidad.edu",
                          hintStyle: TextStyle(
                            color: AppColors.accent,
                            fontSize: 18,
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

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDarker,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    "Enviar Instrucciones",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Text(
                    "¿Recuerdas tu contraseña? Inicia Sesión",
                    style: TextStyle(
                      color: AppColors.primaryDarker,
                      fontSize: 16,
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
