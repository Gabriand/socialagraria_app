import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/page_transitions.dart';
import 'package:social_agraria/views/screens/basic_info.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool passVisible = false;
  bool passVisible2 = false;

  String password = "";
  String confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 32,
                color: AppColors.primaryDarker,
              ),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),

            SizedBox(height: AppDimens.espacioLarge),

            Text(
              "Crea tu Cuenta",
              style: TextStyle(
                fontSize: AppDimens.fontSizeTitleLarge,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDarker,
              ),
            ),

            SizedBox(height: AppDimens.espacioSmall),

            Text(
              "Usa tu correo electrónico institucional para comenzar.",
              style: TextStyle(
                fontSize: AppDimens.fontSizeSubtitle,
                height: 1.4,
                color: AppColors.primaryDarker,
              ),
            ),

            SizedBox(height: AppDimens.spacing2XLarge),

            Text(
              "Correo Electrónico",
              style: TextStyle(
                fontSize: AppDimens.fontSizeSubtitle,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDarker,
              ),
            ),
            SizedBox(height: AppDimens.espacioSmall),

            _inputBox(
              icon: Icons.email_outlined,
              hint: "Correo electrónico universitario",
              obscure: false,
              onChanged: (_) {},
            ),

            SizedBox(height: AppDimens.espacioLarge),

            Text(
              "Contraseña",
              style: TextStyle(
                fontSize: AppDimens.fontSizeSubtitle,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDarker,
              ),
            ),
            const SizedBox(height: 10),

            _inputBox(
              icon: Icons.lock_outline,
              hint: "Crea una contraseña",
              obscure: !passVisible,
              suffix: IconButton(
                icon: Icon(
                  passVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.primaryDarker,
                ),
                onPressed: () => setState(() => passVisible = !passVisible),
              ),
              onChanged: (v) => setState(() => password = v),
            ),

            SizedBox(height: AppDimens.espacioLarge),

            Text(
              "Confirmar Contraseña",
              style: TextStyle(
                fontSize: AppDimens.fontSizeSubtitle,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDarker,
              ),
            ),
            const SizedBox(height: 10),

            _inputBox(
              icon: Icons.lock_outline,
              hint: "Vuelve a escribir la contraseña",
              obscure: !passVisible2,
              suffix: IconButton(
                icon: Icon(
                  passVisible2 ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.primaryDarker,
                ),
                onPressed: () => setState(() => passVisible2 = !passVisible2),
              ),
              onChanged: (v) => setState(() => confirmPassword = v),
            ),

            const SizedBox(height: 30),

            _check(password.length >= 8, "Mínimo 8 caracteres"),
            _check(
              password.contains(RegExp(r'[A-Z]')),
              "Al menos una letra mayúscula",
            ),
            _check(password.contains(RegExp(r'[0-9]')), "Al menos un número"),
            _check(
              password.contains(RegExp(r'[!@#\$%^&*(),.?\":{}|<>]')),
              "Al menos un símbolo especial",
            ),

            SizedBox(height: AppDimens.spacing2XLarge),

            SizedBox(
              width: double.infinity,
              height: AppDimens.buttonHeightLarge,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDarker,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusRound),
                  ),
                ),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(PageTransitions.slideFromRight(const BasicInfo()));
                },
                child: Text(
                  "Siguiente",
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeSubtitle,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _inputBox({
    required IconData icon,
    required String hint,
    required bool obscure,
    Widget? suffix,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                obscureText: obscure,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                ),
                onChanged: onChanged,
              ),
            ),
            if (suffix != null) suffix,
          ],
        ),
      ),
    );
  }

  Widget _check(bool ok, String text) {
    return Row(
      children: [
        Icon(
          ok ? Icons.check_circle : Icons.circle_outlined,
          color: ok ? AppColors.primary : AppColors.primaryDarker,
          size: 26,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: AppDimens.fontSizeSubtitle,
            color: AppColors.primaryDarker,
          ),
        ),
      ],
    );
  }
}
