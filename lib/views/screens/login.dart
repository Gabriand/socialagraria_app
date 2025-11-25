import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/page_transitions.dart';
import 'package:social_agraria/views/screens/root.dart';
import 'package:social_agraria/views/screens/create_account.dart';
import 'package:social_agraria/views/screens/restore_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),

                  Icon(
                    Icons.school_outlined,
                    size: 120,
                    color: AppColors.primaryDarker,
                  ),

                  const SizedBox(height: 40),

                  Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      color: AppColors.primaryDarker,
                      fontSize: AppDimens.fontSizeTitleLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: AppDimens.espacioSmall),

                  Text(
                    'Ingresa a tu cuenta para continuar.',
                    style: TextStyle(
                      color: AppColors.primaryDarker,
                      fontSize: AppDimens.fontSizeSubtitle,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppDimens.spacing2XLarge),

                  _buildInputField(
                    label: "Correo Electrónico",
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 20),

                  _buildInputField(
                    label: "Contraseña",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    height: AppDimens.buttonHeightLarge,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDarker,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusMedium,
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacement(PageTransitions.fade(const Root()));
                      },
                      child: const Text(
                        "Iniciar Sesión",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: AppDimens.fontSizeSubtitle,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageTransitions.slideFromRight(const RestorePassword()),
                      );
                    },
                    child: Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "¿No tienes una cuenta?",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            PageTransitions.slideFromRight(
                              const CreateAccount(),
                            ),
                          );
                        },
                        child: Text(
                          "Crear cuenta",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          icon: Icon(icon, color: AppColors.accent),
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(color: AppColors.accent, fontSize: 18),
        ),
      ),
    );
  }
}
