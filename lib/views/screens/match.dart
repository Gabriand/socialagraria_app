import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';

class Match extends StatelessWidget {
  const Match({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CÍRCULOS
              SizedBox(
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.translate(
                      offset: const Offset(-30, 0),
                      child: _circle(),
                    ),
                    Transform.translate(
                      offset: const Offset(30, 0),
                      child: _circle(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "¡Es un Match!",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDarker,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "A ambos os habéis gustado.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  height: 1.4,
                  color: AppColors.primaryDarker,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Ver Mis Matches",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Continuar Explorando",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDarker,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circle() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accent, width: 6),
      ),
    );
  }
}
