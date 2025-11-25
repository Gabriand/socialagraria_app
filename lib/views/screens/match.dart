import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/page_transitions.dart';
import 'package:social_agraria/views/screens/root.dart';

class Match extends StatelessWidget {
  const Match({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
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

              SizedBox(height: AppDimens.espacioXLarge + 8),

              Text(
                "¡Es un Match!",
                style: TextStyle(
                  fontSize: AppDimens.fontSizeTitleLarge + 10,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDarker,
                ),
              ),

              SizedBox(height: AppDimens.espacioSmall + 4),

              Text(
                "A ambos os habéis gustado.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.fontSizeSubtitle + 2,
                  height: 1.4,
                  color: AppColors.primaryDarker,
                ),
              ),

              SizedBox(height: AppDimens.espacioXLarge + 8),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: AppDimens.paddingMedium + 2,
                    ),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimens.spacing2XLarge,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      PageTransitions.fade(const Root(initialIndex: 1)),
                    );
                  },
                  child: Text(
                    "Ver Mis Matches",
                    style: TextStyle(
                      fontSize: AppDimens.fontSizeSubtitle + 2,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppDimens.espacioLarge + 1),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    PageTransitions.fade(const Root(initialIndex: 0)),
                  );
                },
                child: Text(
                  "Continuar Explorando",
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeSubtitle + 2,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarker,
                  ),
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
