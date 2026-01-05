import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/models/services/supabase.dart';

class RestorePassword extends StatefulWidget {
  const RestorePassword({super.key});

  @override
  State<RestorePassword> createState() => _RestorePasswordState();
}

class _RestorePasswordState extends State<RestorePassword> {
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_emailController.text.isEmpty) {
      _showMessage('Por favor ingresa tu correo electrónico', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.resetPassword(_emailController.text.trim());
      setState(() => _emailSent = true);
      _showMessage('Se han enviado las instrucciones a tu correo');
    } catch (e) {
      _showMessage('Error al enviar instrucciones', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    }
  }

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
                  "Ingresa tu correo electrónico para recibir las instrucciones "
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
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "tucorreo@email.com",
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

              if (_emailSent)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Revisa tu bandeja de entrada',
                            style: TextStyle(color: Colors.green[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              SizedBox(height: AppDimens.spacing2XLarge),

              SizedBox(
                width: double.infinity,
                height: AppDimens.buttonHeightLarge,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleResetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDarker,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusMedium,
                      ),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: AppColors.white)
                      : Text(
                          _emailSent
                              ? "Reenviar Instrucciones"
                              : "Enviar Instrucciones",
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
