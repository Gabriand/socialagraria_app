import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/page_transitions.dart';
import 'package:social_agraria/views/screens/login.dart';
import 'package:social_agraria/views/screens/root.dart';
import 'package:social_agraria/views/screens/basic_info.dart';
import 'package:social_agraria/views/screens/create_account.dart';
import 'package:social_agraria/models/services/supabase.dart';
import 'package:social_agraria/controllers/user_controller.dart';
import 'package:social_agraria/models/registration_data.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    // Guardar referencias antes de async para evitar usar context después de gaps
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final userController = context.read<UserController>();

    try {
      await _authService.signInWithGoogle();

      if (mounted) {
        // Verificar si el usuario ya tiene perfil
        final hasProfile = await userController.ensureProfileExists();

        if (!mounted) return;

        if (hasProfile && userController.profile != null) {
          // Si tiene perfil completo, ir al home
          if (userController.profile!.hasBasicInfo) {
            navigator.pushReplacement(PageTransitions.fade(const Root()));
          } else {
            // Si el perfil está incompleto, ir a completar datos
            navigator.pushReplacement(
              PageTransitions.fade(
                BasicInfo(
                  registrationData: RegistrationData(
                    email: SupabaseService.currentUser?.email ?? '',
                    password: '', // No necesario para Google
                  ),
                ),
              ),
            );
          }
        } else {
          // Crear perfil nuevo
          navigator.pushReplacement(
            PageTransitions.fade(
              BasicInfo(
                registrationData: RegistrationData(
                  email: SupabaseService.currentUser?.email ?? '',
                  password: '',
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
                "¡Hola!",
                style: TextStyle(
                  fontSize: AppDimens.fontSizeTitleLarge + 8,
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

              // Botón principal de Google (más prominente)
              GestureDetector(
                onTap: _isLoading ? null : _handleGoogleLogin,
                child: Container(
                  width: double.infinity,
                  height: AppDimens.buttonHeightMedium + 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/icon-google.png',
                              width: AppDimens.iconSizeLarge,
                              height: AppDimens.iconSizeLarge,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.g_mobiledata,
                                    color: AppColors.white,
                                    size: 30,
                                  ),
                            ),
                            SizedBox(width: AppDimens.espacioSmall + 4),
                            Text(
                              "Continuar con Google",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppDimens.fontSizeSubtitle + 1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              SizedBox(height: AppDimens.espacioLarge),

              // Divisor "o"
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.primaryDarker.withValues(alpha: 0.3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "o",
                      style: TextStyle(
                        color: AppColors.primaryDarker.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.primaryDarker.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppDimens.espacioLarge),

              // Botón secundario para email
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
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      AppDimens.radiusMedium - 2,
                    ),
                    border: Border.all(
                      color: AppColors.primaryDarker,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Ingresar con Email",
                      style: TextStyle(
                        color: AppColors.primaryDarker,
                        fontSize: AppDimens.fontSizeSubtitle,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppDimens.espacioLarge),

              // Link para crear cuenta
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¿No tienes cuenta? ",
                    style: TextStyle(
                      color: AppColors.primaryDarker.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageTransitions.slideFromRight(const CreateAccount()),
                      );
                    },
                    child: Text(
                      "Regístrate",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppDimens.espacioXLarge),

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
